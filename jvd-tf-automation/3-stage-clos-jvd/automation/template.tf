# create template with three racks - single, ESI and border

resource "apstra_template_rack_based" "dc1_template" {
  name                     = "dc1_template"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "evpn"
  spine = {
    logical_device_id = apstra_logical_device.vJunos_LD.id
    count             = 2
  }
  rack_infos = {
     (apstra_rack_type.dc1_single.id) = { count = 1 }
     (apstra_rack_type.dc1_esi_esxi.id) = { count = 1 }
     (apstra_rack_type.dc1_border.id) = { count = 1 }
  }
}

## rackname_rack#_leafname#