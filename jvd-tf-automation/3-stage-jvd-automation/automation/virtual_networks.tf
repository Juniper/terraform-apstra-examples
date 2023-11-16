# create VNs per routing zone

// when attaching VNs to a paired switch (such as ESI LAG), do not use
// individual node IDs for bindings since a pair is represented as one 
// logical node in Apstra's graph db. Instead, use binding constructor
// and find out the node ID for the logical node.

data "apstra_datacenter_virtual_network_binding_constructor" "all" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  switch_ids   = [ 
    apstra_datacenter_device_allocation.devices["leaf1"].node_id,
    apstra_datacenter_device_allocation.devices["leaf2"].node_id,
    apstra_datacenter_device_allocation.devices["leaf3"].node_id,
    apstra_datacenter_device_allocation.devices["leaf4"].node_id,
    apstra_datacenter_device_allocation.devices["leaf5"].node_id
    ]
}

resource "apstra_datacenter_virtual_network" "dc1_vn1_blue" {
  name                         = "dc1_vn1_blue"
  blueprint_id                 = apstra_datacenter_blueprint.dc1_blueprint.id
  type                         = "vxlan"
  routing_zone_id              = apstra_datacenter_routing_zone.blue.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  ipv4_virtual_gateway         = "10.12.1.1"
  ipv4_subnet                  = "10.12.1.0/24"
  vni                          = "12001"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.all.bindings
}

resource "apstra_datacenter_virtual_network" "dc1_vn2_blue" {
  name                         = "dc1_vn2_blue"
  blueprint_id                 = apstra_datacenter_blueprint.dc1_blueprint.id
  type                         = "vxlan"
  routing_zone_id              = apstra_datacenter_routing_zone.blue.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  ipv4_virtual_gateway         = "10.12.2.1"
  ipv4_subnet                  = "10.12.2.0/24"
  vni                          = "12002"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.all.bindings
}

resource "apstra_datacenter_virtual_network" "dc1_vn1_red" {
  name                         = "dc1_vn1_red"
  blueprint_id                 = apstra_datacenter_blueprint.dc1_blueprint.id
  type                         = "vxlan"
  routing_zone_id              = apstra_datacenter_routing_zone.red.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  ipv4_virtual_gateway         = "10.11.1.1"
  ipv4_subnet                  = "10.11.1.0/24"
  vni                          = "11001"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.all.bindings
}

resource "apstra_datacenter_virtual_network" "dc1_vn2_red" {
  name                         = "dc1_vn2_red"
  blueprint_id                 = apstra_datacenter_blueprint.dc1_blueprint.id
  type                         = "vxlan"
  routing_zone_id              = apstra_datacenter_routing_zone.red.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  ipv4_virtual_gateway         = "10.11.2.1"
  ipv4_subnet                  = "10.11.2.0/24"
  vni                          = "11002"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.all.bindings
}

# create data sources to retrieve IDs of each VN created

// example output of data source below

data "apstra_datacenter_virtual_networks" "dc1_vn1_red" {
  depends_on = [apstra_datacenter_virtual_network.dc1_vn1_red] // needed otherwise data source will run too early
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  filter = {
    name = "dc1_vn1_red"
  }
}

data "apstra_datacenter_virtual_networks" "dc1_vn2_red" {
  depends_on = [apstra_datacenter_virtual_network.dc1_vn2_red] // needed otherwise data source will run too early
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  filter = {
    name = "dc1_vn2_red"
  }
}

data "apstra_datacenter_virtual_networks" "dc1_vn1_blue" {
  depends_on = [apstra_datacenter_virtual_network.dc1_vn1_blue] // needed otherwise data source will run too early
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  filter = {
    name = "dc1_vn1_blue"
  }
}

data "apstra_datacenter_virtual_networks" "dc1_vn2_blue" {
  depends_on = [apstra_datacenter_virtual_network.dc1_vn2_blue] // needed otherwise data source will run too early
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  filter = {
    name = "dc1_vn2_blue"
  }
}