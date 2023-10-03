# create template which takes rack ID as an input
# static overlay is used to create just a routed IP fabric

resource "apstra_template_rack_based" "frontend_template" {
  name                     = "AI_Frontend_Template"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    logical_device_id = data.apstra_logical_device.frontend_devices.id # taken from rack TF file
    count             = 2
  }
  rack_infos = {
     (apstra_rack_type.frontend_rack.id) = { count = 1 }
  }
}