#
# Instantiate a blueprints from the previously created templates
#

resource "apstra_datacenter_blueprint" "gpus_bp" {
  name        = "Backend GPU Fabric"
  template_id = apstra_template_rack_based.AI_Cluster_GPUs.id
}

resource "apstra_datacenter_blueprint" "storage_bp" {
  name        = "Backend Storage Fabric"
  template_id = apstra_template_rack_based.AI_Cluster_Storage.id
}

resource "apstra_datacenter_blueprint" "mgmt_bp" {
  name        = "Frontend Management Fabric"
  template_id = apstra_template_rack_based.AI_Cluster_Mgmt.id
}

locals {
  blueprints = [
    apstra_datacenter_blueprint.gpus_bp,
    apstra_datacenter_blueprint.mgmt_bp,
    apstra_datacenter_blueprint.storage_bp,
  ]
  asn_pool_roles = ["spine", "leaf"]
  first_asn = 100
  asn_pool_size = 100
}

resource "apstra_asn_pool" "all" {
  count = (length(local.blueprints) * length(local.asn_pool_roles))
  name = "${local.blueprints[count.index % length(local.blueprints)].name} ${local.asn_pool_roles[count.index % length(local.asn_pool_roles)]}"
  ranges = [
    {
      first = local.first_asn + (count.index * local.asn_pool_size)
      last = local.first_asn + (count.index * local.asn_pool_size) + local.asn_pool_size - 1
    }
  ]
}

resource "apstra_datacenter_resource_pool_allocation" "asns" {
  count = (length(local.blueprints) * length(local.asn_pool_roles))
  blueprint_id = "${local.blueprints[count.index % length(local.blueprints)].id}"
  pool_ids = [apstra_asn_pool.all[count.index].id]
  role = "${local.asn_pool_roles[count.index % length(local.asn_pool_roles)]}_asns"
}
