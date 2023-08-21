resource "apstra_datacenter_routing_zone" "blue" {
  name         = "blue"
  blueprint_id = apstra_datacenter_blueprint.lab_guide.id
  vni          = 5000

}


resource "apstra_datacenter_resource_pool_allocation" "routing_zone_leaf_loopback_ips" {
  blueprint_id    = apstra_datacenter_blueprint.lab_guide.id
  role            = "leaf_loopback_ips"
  pool_ids        = [apstra_ipv4_pool.lab_guide.id]
  routing_zone_id = apstra_datacenter_routing_zone.blue.id
}

resource "apstra_datacenter_resource_pool_allocation" "routing_zone_svi_subnets_ips" {
  blueprint_id    = apstra_datacenter_blueprint.lab_guide.id
  role            = "virtual_network_svi_subnets"
  pool_ids        = [apstra_ipv4_pool.lab_guide.id]
  routing_zone_id = apstra_datacenter_routing_zone.blue.id
}



#resource "apstra_datacenter_resource_pool_allocation" "routing_zone_resource_pool" {
#  blueprint_id    = apstra_datacenter_blueprint.lab_guide.id
#  role            = "virtual_network_svi_subnets"
#  pool_ids        = [apstra_ipv4_pool.lab_guide.id]
#  routing_zone_id = apstra_datacenter_routing_zone.blue.id
#}
#
#resource "apstra_datacenter_resource_pool_allocation" "routing_zone_vni_pool" {
#  blueprint_id    = apstra_datacenter_blueprint.lab_guide.id
#  role            = "vni_virtual_network_ids"
#  pool_ids        = ["Default-10000-20000"]
#  routing_zone_id = apstra_datacenter_routing_zone.blue.id
#}
