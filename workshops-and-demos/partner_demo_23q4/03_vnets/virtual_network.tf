

#resource "apstra_datacenter_virtual_network" "single" {
#  blueprint_id    = local.blueprint_id
#  name            = "network_one"
#  routing_zone_id = apstra_datacenter_routing_zone.a.id
#  bindings        = local.bindings
#}











resource "apstra_datacenter_virtual_network" "hypervisor" {
  count = local.hypervisor_vlan_count
  blueprint_id    = local.blueprint_id
  name            = "hypervisor_net_${count.index + 1}"
  routing_zone_id = apstra_datacenter_routing_zone.a.id
  bindings        = data.apstra_datacenter_virtual_network_binding_constructor.example.bindings
}

resource "apstra_datacenter_virtual_network" "kubernetes" {
  count = local.kubernetes_vlan_count
  blueprint_id    = local.blueprint_id
  name            = "kubernetes_net_${count.index + 1}"
  routing_zone_id = apstra_datacenter_routing_zone.a.id
  bindings        = data.apstra_datacenter_virtual_network_binding_constructor.example.bindings
}
