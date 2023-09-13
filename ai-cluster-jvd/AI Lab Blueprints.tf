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

  asn_pool_roles = ["spine_asns", "leaf_asns"]
  first_asn      = 100
  asn_pool_size  = 100

  ipv4_pool_roles       = ["spine_loopback_ips", "leaf_loopback_ips", "spine_leaf_link_ips"]
  ipv4_block           = "10.0.0.0/8"
  ipv4_pool_extra_bits = 16
}

resource "apstra_asn_pool" "all" {
  count = (length(local.blueprints) * length(local.asn_pool_roles))
  name = format("%s %s",
    local.blueprints[floor(count.index / length(local.asn_pool_roles))].name,
    replace(title(replace(local.asn_pool_roles[count.index % length(local.asn_pool_roles)], "_", " ")), "Asns", "ASNs"),
  )
  ranges = [
    {
      first = local.first_asn + (count.index * local.asn_pool_size)
      last  = local.first_asn + (count.index * local.asn_pool_size) + local.asn_pool_size - 1
    }
  ]
}

resource "apstra_datacenter_resource_pool_allocation" "asns" {
  count        = (length(local.blueprints) * length(local.asn_pool_roles))
  blueprint_id = local.blueprints[floor(count.index / length(local.asn_pool_roles))].id
  pool_ids     = [apstra_asn_pool.all[count.index].id]
  role         = local.asn_pool_roles[count.index % length(local.asn_pool_roles)]
}

resource "apstra_ipv4_pool" "all" {
  count   = (length(local.blueprints) * length(local.ipv4_pool_roles))
  name = format("%s %s",
    local.blueprints[floor(count.index / length(local.ipv4_pool_roles))].name,
    replace(title(replace(local.ipv4_pool_roles[count.index % length(local.ipv4_pool_roles)], "_", " ")), "Ips", "IPs"),
  )
  subnets = [{ network = cidrsubnet(local.ipv4_block, local.ipv4_pool_extra_bits, count.index) }]
}

resource "apstra_datacenter_resource_pool_allocation" "ipv4" {
  count        = (length(local.blueprints) * length(local.ipv4_pool_roles))
  blueprint_id = local.blueprints[floor(count.index / length(local.ipv4_pool_roles))].id
  pool_ids     = [apstra_ipv4_pool.all[count.index].id]
  role = local.ipv4_pool_roles[count.index % length(local.ipv4_pool_roles)]
}