resource "apstra_datacenter_blueprint" "dc_1" {
  name        = "DC 1"
  template_id = local.template_id
}

resource "apstra_datacenter_resource_pool_allocation" "spine_lo" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  role         = "spine_loopback_ips"
  pool_ids     = [ apstra_ipv4_pool.spine.id ]
}

resource "apstra_datacenter_resource_pool_allocation" "leaf_lo" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  role         = "leaf_loopback_ips"
  pool_ids     = [ apstra_ipv4_pool.leaf.id ]
}

resource "apstra_datacenter_resource_pool_allocation" "spine_leaf" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  role         = "spine_leaf_link_ips"
  pool_ids     = [ apstra_ipv4_pool.spine_leaf.id ]
}

resource "apstra_datacenter_resource_pool_allocation" "spine_asn" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  role         = "spine_asns"
  pool_ids     = [ apstra_asn_pool.spine.id ]
}

resource "apstra_datacenter_resource_pool_allocation" "leaf_asn" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  role         = "leaf_asns"
  pool_ids     = [ apstra_asn_pool.leaf.id ]
}

resource "apstra_datacenter_device_allocation" "all" {
  for_each = local.interface_maps
  blueprint_id             = apstra_datacenter_blueprint.dc_1.id
  initial_interface_map_id = each.value
  node_name                = each.key
}
