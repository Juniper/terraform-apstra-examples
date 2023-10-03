# first retrieve ID of Logical Device for leaf/spine (5220-32c)
# this is AOS-24x100+8x400-1

data "apstra_logical_device" "frontend_devices" {
    name = "AOS-24x100+8x400-1"
}

resource "apstra_rack_type" "frontend_rack" {
  name                       = "AI_Frontend"
  description                = "Created by Terraform"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    leaf1 = { // "leaf switch" on this line is the name used by links targeting this switch.
      logical_device_id   = data.apstra_logical_device.frontend_devices.id
      spine_link_count    = 2
      spine_link_speed    = "400G"
    },
    leaf2 = { // "leaf switch" on this line is the name used by links targeting this switch.
      logical_device_id   = data.apstra_logical_device.frontend_devices.id
      spine_link_count    = 2
      spine_link_speed    = "400G"
    }
  }
  generic_systems = {
    A100 = {
      count             = 8
      logical_device_id = "AOS-1x100-1"
      links = {
        link = {
          speed              = "100G"
          target_switch_name = "leaf1"
          tag_ids = [apstra_tag.host_tags["a100"].id]
        }
      }
    },
    Storage = {
      count             = 8
      logical_device_id = "AOS-1x100-1"
      links = {
        link = {
          speed              = "100G"
          target_switch_name = "leaf2"
          tag_ids = [apstra_tag.host_tags["storage"].id]
        }
      }
    },
    H100 = {
      count             = 4
      logical_device_id = "AOS-1x100-1"
      links = {
        link = {
          speed              = "100G"
          target_switch_name = "leaf1"
          tag_ids = [apstra_tag.host_tags["h100"].id]
        }
      }
    },
    Headend_Servers = {
      count             = 3
      logical_device_id = "AOS-1x100-1"
      links = {
        link = {
          speed              = "100G"
          target_switch_name = "leaf1"
          tag_ids = [apstra_tag.host_tags["headend"].id]
        }
      }
    }
  }
}