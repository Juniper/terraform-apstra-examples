resource "apstra_datacenter_routing_zone" "your_routing_zone" {
  name         = var.name
  blueprint_id = var.blueprint_id
  vlan_id      = var.vlan_id #optional
  vni          = var.vni     #optional
  dhcp_servers = var.dhcp_servers  #optional
}


resource "apstra_datacenter_resource_pool_allocation" "ipv4" {

  blueprint_id    = var.blueprint_id
  routing_zone_id = apstra_datacenter_routing_zone.your_routing_zone.id

  role     = var.role
  pool_ids = var.pool_ids

}