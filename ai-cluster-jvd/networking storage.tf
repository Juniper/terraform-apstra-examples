#
# Setup the backend storage fabric networking with L3 routing only
#

# Get ID of default routing zone for this

data "apstra_datacenter_routing_zone" "storage_default_rz" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  name         = "default"
}

# Create IP Link data source for CT for storage L3 connections down to GPU Storage links and Weka Storage

data "apstra_datacenter_ct_ip_link" "l3_to_storage" {
  routing_zone_id      = data.apstra_datacenter_routing_zone.storage_default_rz.id
  ipv4_addressing_type = "numbered"
  ipv6_addressing_type = "none"
}

# Create the L3 IP Link CT by attaching primitive from data source

resource "apstra_datacenter_connectivity_template" "storage_l3_ct" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  name         = "L3_to_Storage"
  description  = "L3 link to Storage nodes for IP connectivity in IP Fabric"
  primitives = [
    data.apstra_datacenter_ct_ip_link.l3_to_storage.primitive
  ]
}

#
# Assign Storage CT
#

data "apstra_datacenter_interfaces_by_link_tag" "storage_weka_links" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  tags         = ["storage_weka"]
}



resource "apstra_datacenter_connectivity_template_assignment" "storage_assign_ct_weka" {
  count                = apstra_rack_type.storage_weka.generic_systems.weka_storage.count * local.storage_weka_rack_leaf_count
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.storage_weka_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.storage_l3_ct.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "storage_ai_links_h100" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  tags         = ["storage_h100"]
}

resource "apstra_datacenter_connectivity_template_assignment" "storage_assign_ct_h100" {
  count                = apstra_rack_type.storage_ai.generic_systems.dgx-h100-storage.count * local.storage_rack_leaf_count
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.storage_ai_links_h100.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.storage_l3_ct.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "storage_ai_links_a100" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  tags         = ["storage_a100"]
}

resource "apstra_datacenter_connectivity_template_assignment" "storage_assign_ct_a100" {
  count                = apstra_rack_type.storage_ai.generic_systems.hgx-a100-storage-1.count + apstra_rack_type.storage_ai.generic_systems.hgx-a100-storage-2.count
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.storage_ai_links_a100.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.storage_l3_ct.id
  ]
}

resource "apstra_ipv4_pool" "storage_subnet" {
  name = "Storage subnet pool"
  subnets = [
    { network = "10.100.0.0/16" },
  ]
}

resource "apstra_datacenter_resource_pool_allocation" "storage_subnet_alloc" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  pool_ids     = [apstra_ipv4_pool.storage_subnet.id]
  role         = "to_generic_link_ips"
}
