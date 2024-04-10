resource "apstra_rack_type" "storage" {
  name                       = "AAA Storage"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    leaf = {
      logical_device_id   = apstra_logical_device.storage_leaf.id
      spine_link_count    = 4
      spine_link_speed    = "100G"
      redundancy_protocol = "esi"
    }
  }
}

resource "apstra_rack_type" "compute" {
  name                       = "AAA Compute"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    leaf = {
      logical_device_id   = "AOS-48x25_4x100-1"
      spine_link_count    = 1
      spine_link_speed    = "100G"
      redundancy_protocol = "esi"
    }
  }
}
