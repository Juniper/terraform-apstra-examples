data "apstra_datacenter_ct_routing_policy" "vpn" {
  for_each          = apstra_datacenter_routing_policy.vpn
  routing_policy_id = each.value.id
}

data "apstra_datacenter_ct_bgp_peering_ip_endpoint" "vpn" {
  ipv4_address     = var.vpn_edge_router_ip
  child_primitives = [for k, v in data.apstra_datacenter_ct_routing_policy.vpn : v.primitive]
}

data "apstra_datacenter_ct_ip_link" "vpn" {
  routing_zone_id      = var.routing_zone_id
  ipv4_addressing_type = "numbered"
  child_primitives     = [data.apstra_datacenter_ct_bgp_peering_ip_endpoint.vpn.primitive]
}

resource "apstra_datacenter_connectivity_template" "vpn" {
  blueprint_id = var.blueprint_id
  name         = "IP+BGP handoff to VPN block"
  description  = "includes routing policies for [${join(", ", [for k, v in apstra_datacenter_routing_policy.vpn : k])}]"
  tags         = [
    "test",
    "terraform",
  ]
  primitives   = [
    data.apstra_datacenter_ct_ip_link.vpn.primitive
  ]
}
