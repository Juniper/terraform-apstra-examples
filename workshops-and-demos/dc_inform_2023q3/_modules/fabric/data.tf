data "apstra_blueprint_deployment" "dc_1" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  depends_on = [
    apstra_datacenter_resource_pool_allocation.spine_asn,
    apstra_datacenter_resource_pool_allocation.leaf_asn,
    apstra_datacenter_resource_pool_allocation.spine_leaf,
    apstra_datacenter_resource_pool_allocation.spine_lo,
    apstra_datacenter_resource_pool_allocation.leaf_lo,
    apstra_datacenter_device_allocation.all,
  ]
}

data "apstra_datacenter_routing_zone" "default" {
  blueprint_id = apstra_datacenter_blueprint.dc_1.id
  name         = "default"
}
