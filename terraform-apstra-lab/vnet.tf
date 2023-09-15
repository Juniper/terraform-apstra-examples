locals {
  app_names = [
    "App1",
    "App2",
    "App3",
    "App4",
    "App5",
  ]
}

data "apstra_datacenter_systems" "leafs" {
  blueprint_id = apstra_datacenter_blueprint.lab_guide.id
  filter = {
    role        = "leaf"
    system_type = "switch"
  }
}

data "apstra_datacenter_virtual_network_binding_constructor" "vnet_bindng_constructor" {
  blueprint_id = apstra_datacenter_blueprint.lab_guide.id
  switch_ids   = data.apstra_datacenter_systems.leafs.ids
}


resource "apstra_datacenter_virtual_network" "app_networks" {
  for_each                     = toset(local.app_names)
  name                         = each.key
  blueprint_id                 = apstra_datacenter_blueprint.lab_guide.id
  type                         = "vxlan"
  routing_zone_id              = apstra_datacenter_routing_zone.blue.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = data.apstra_datacenter_virtual_network_binding_constructor.vnet_bindng_constructor.bindings
}
