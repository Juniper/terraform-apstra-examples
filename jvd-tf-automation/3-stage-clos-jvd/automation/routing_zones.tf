# create routing zones in Apstra which translate to IP VRFs on the devices

resource "apstra_datacenter_routing_zone" "red" {
  name              = "red"
  blueprint_id      = apstra_datacenter_blueprint.dc1_blueprint.id
  vlan_id           = 2                                    # optional
  vni               = 20001                                # optional
}

resource "apstra_datacenter_routing_zone" "blue" {
  name              = "blue"
  blueprint_id      = apstra_datacenter_blueprint.dc1_blueprint.id
  vlan_id           = 3                                    # optional
  vni               = 20002                                # optional
}

# assign loopbacks for each routing zone

resource "apstra_datacenter_resource_pool_allocation" "red_rz_loopback" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id // adds implicit dependency on blueprint creation
  role         = "leaf_loopback_ips"
  pool_ids     = [apstra_ipv4_pool.evpn_loopback.id]
  routing_zone_id = apstra_datacenter_routing_zone.red.id // adds implicit dependency on RZ creation
}

resource "apstra_datacenter_resource_pool_allocation" "blue_rz_loopback" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id // adds implicit dependency on blueprint creation
  role         = "leaf_loopback_ips"
  pool_ids     = [apstra_ipv4_pool.evpn_loopback.id]
  routing_zone_id = apstra_datacenter_routing_zone.blue.id // adds implicit dependency on RZ creation
}
