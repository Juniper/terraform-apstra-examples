data "apstra_blueprint_deployment" "dc_1" {
  blueprint_id = var.blueprint_id
  depends_on = [
    apstra_datacenter_routing_policy.vpn
  ]
}
