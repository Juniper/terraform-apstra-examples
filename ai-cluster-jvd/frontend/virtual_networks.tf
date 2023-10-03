# use binding constructor and find out the node ID for the logical node in graph db

data "apstra_datacenter_virtual_network_binding_constructor" "leaf1" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  switch_ids   = [
    apstra_datacenter_device_allocation.assigned_leafs["ai_frontend_001_leaf1"].node_id
    ]
}

data "apstra_datacenter_virtual_network_binding_constructor" "leaf2" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  switch_ids   = [
    apstra_datacenter_device_allocation.assigned_leafs["ai_frontend_001_leaf2"].node_id
    ]
}

# get ID of default routing zone

data "apstra_datacenter_routing_zone" "default" {
  blueprint_id   = apstra_datacenter_blueprint.frontend_blueprint.id
  name           = "default"
}

# create virtual networks in blueprint

resource "apstra_datacenter_virtual_network" "a100_vn" {
  name                         = "A100_VN"
  blueprint_id                 = apstra_datacenter_blueprint.frontend_blueprint.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.1.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.leaf1.bindings
}

resource "apstra_datacenter_virtual_network" "h100_vn" {
  name                         = "H100_VN"
  blueprint_id                 = apstra_datacenter_blueprint.frontend_blueprint.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.2.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.leaf1.bindings
}

resource "apstra_datacenter_virtual_network" "headend_vn" {
  name                         = "Headend_VN"
  blueprint_id                 = apstra_datacenter_blueprint.frontend_blueprint.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.3.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.leaf1.bindings
}

resource "apstra_datacenter_virtual_network" "storage_vn" {
  name                         = "Storage_VN"
  blueprint_id                 = apstra_datacenter_blueprint.frontend_blueprint.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.4.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.leaf2.bindings
}