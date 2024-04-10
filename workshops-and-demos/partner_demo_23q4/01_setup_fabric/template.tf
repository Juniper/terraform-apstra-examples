# Create a template using previously looked-up (data) spine info and previously
# created (resource) rack types.
resource "apstra_template_rack_based" "a" {
  name                     = "AAA Template"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "evpn"
  spine = {
    count             = 4
    logical_device_id = "AOS-32x100-1"
  }
  rack_infos = {
    (apstra_rack_type.storage.id)    = { count = ceil(local.max_storage_nodes / local.storage_nodes_per_rack) }
    (apstra_rack_type.compute.id)    = { count = ceil(local.max_compute_nodes / local.compute_nodes_per_rack) }
  }
}