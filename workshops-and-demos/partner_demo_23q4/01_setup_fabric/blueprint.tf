resource "apstra_datacenter_blueprint" "a" {
  name        = "AAA Demo"
  template_id = apstra_template_rack_based.a.id
}

resource "apstra_datacenter_resource_pool_allocation" "fabric_asn" {
  for_each     = toset(["spine_asns", "leaf_asns"])
  blueprint_id = apstra_datacenter_blueprint.a.id
  role         = each.key
  pool_ids     = ["Private-64512-65534"]
}

resource "apstra_datacenter_resource_pool_allocation" "fabric_ip4" {
  for_each     = toset(["spine_loopback_ips", "leaf_loopback_ips", "spine_leaf_link_ips"])
  blueprint_id = apstra_datacenter_blueprint.a.id
  role         = each.key
  pool_ids     = ["Private-192_168_0_0-16"]
}

resource "apstra_datacenter_device_allocation" "spine" {
  count                    = apstra_template_rack_based.a.spine.count
  blueprint_id             = apstra_datacenter_blueprint.a.id
  initial_interface_map_id = "Juniper_QFX5120-32C_Junos__AOS-32x100-1"
  node_name                = "spine${count.index + 1}"
}

resource "apstra_datacenter_device_allocation" "storage_leaf" {
  count                    = ceil(local.max_storage_nodes / local.storage_nodes_per_rack) * 2
  blueprint_id             = apstra_datacenter_blueprint.a.id
  initial_interface_map_id = apstra_interface_map.storage_leaf.id
  node_name                = "${replace(lower(apstra_rack_type.storage.name), " ", "_")}_${format("%03d", floor(count.index/2) + 1)}_leaf${(count.index % 2) + 1}"
}

resource "apstra_datacenter_device_allocation" "compute_leaf" {
  count                    = ceil(local.max_compute_nodes / local.compute_nodes_per_rack) * 2
  blueprint_id             = apstra_datacenter_blueprint.a.id
  initial_interface_map_id = "Juniper_EX4650-48Y_Junos__AOS-48x25_4x100-1"
  node_name                = "${replace(lower(apstra_rack_type.compute.name), " ", "_")}_${format("%03d", floor(count.index/2) + 1)}_leaf${(count.index % 2) + 1}"
}

resource "apstra_blueprint_deployment" "aaa" {
  blueprint_id = apstra_datacenter_blueprint.a.id
  depends_on = [
    apstra_datacenter_resource_pool_allocation.fabric_asn,
    apstra_datacenter_resource_pool_allocation.fabric_ip4,
    apstra_datacenter_device_allocation.spine,
    apstra_datacenter_device_allocation.compute_leaf,
    apstra_datacenter_device_allocation.storage_leaf,
  ]
}
