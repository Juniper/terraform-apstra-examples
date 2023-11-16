# create three racks as per JVD - single, ESI based, and border racks

# rack single

resource "apstra_rack_type" "dc1_single" {
  name                       = "dc1_single"
  description                = "Created by Terraform"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    single_leaf = { // "leaf switch" on this line is the name used by links targeting this switch.
      logical_device_id   = apstra_logical_device.vJunos_LD.id
      spine_link_count    = 1
      spine_link_speed    = "10G"
      #redundancy_protocol = "esi" // omit if none has to be used
    }
  }
  generic_systems = {
    h1 = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "single_leaf"
          tag_ids = [apstra_tag.host_tags["h1"].id]
        }
      }
    },
    h2 = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "single_leaf"
          lag_mode = "lacp_active"
          tag_ids = [apstra_tag.host_tags["h2"].id]
        }
      }
    }
  }
}

# rack ESI

resource "apstra_rack_type" "dc1_esi_esxi" {
  name                       = "dc1_esi_esxi"
  description                = "Created by Terraform"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    esi_leaf = { // "leaf switch" on this line is the name used by links targeting this switch.
      logical_device_id   = apstra_logical_device.vJunos_LD.id
      spine_link_count    = 1
      spine_link_speed    = "10G"
      redundancy_protocol = "esi" // omit if none has to be used
    }
  }
  generic_systems = {
    h1 = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "esi_leaf"
          #lag_mode = "lacp_active" // simply omit lag_mode and specify a switch_peer for single homing
          switch_peer = "first"
          tag_ids = [apstra_tag.host_tags["h3"].id]
        }
      }
    },
    h2 = {
      count             = 1
      logical_device_id = "AOS-2x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "esi_leaf"
          lag_mode = "lacp_active"
          tag_ids = [apstra_tag.host_tags["h4"].id]
        }
      }
    },
    h3 = {
      count             = 1
      logical_device_id = "AOS-2x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "esi_leaf"
          lag_mode = "lacp_active"
          tag_ids = [apstra_tag.host_tags["h5"].id]
        }
      }
    },
    h4 = {
      count             = 1
      logical_device_id = "AOS-1x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "esi_leaf"
          #lag_mode = "lacp_active" // simply omit lag_mode and specify a switch_peer for single homing
          switch_peer = "second"
          tag_ids = [apstra_tag.host_tags["h6"].id]
        }
      }
    },
    h5 = {
      count             = 1
      logical_device_id = "AOS-2x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "esi_leaf"
          lag_mode = "lacp_active"
          tag_ids = [apstra_tag.host_tags["h7"].id]
        }
      }
    }
  }
}

# rack border 

resource "apstra_rack_type" "dc1_border" {
  name                       = "dc1_border"
  description                = "Created by Terraform"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    border_leaf = { // "leaf switch" on this line is the name used by links targeting this switch.
      logical_device_id   = apstra_logical_device.vJunos_LD.id
      spine_link_count    = 1
      spine_link_speed    = "10G"
      redundancy_protocol = "esi" // omit if none has to be used
    }
  }
  generic_systems = {
    h1 = {
      count             = 1
      logical_device_id = "AOS-4x10-1"
      links = {
        link1 = {
          speed              = "10G"
          target_switch_name = "border_leaf"
          #lag_mode = "lacp_active" // simply omit lag_mode and specify a switch_peer for single homing
          switch_peer = "first"
        },
        link2 = {
          speed              = "10G"
          target_switch_name = "border_leaf"
          #lag_mode = "lacp_active" // simply omit lag_mode and specify a switch_peer for single homing
          switch_peer = "second"
        },
        link3 = {
          speed              = "10G"
          target_switch_name = "border_leaf"
          lag_mode = "lacp_active"
          tag_ids = [apstra_tag.host_tags["h8"].id]
        }
      }
    },
    h2 = {
      count             = 1
      logical_device_id = "AOS-2x10-1"
      links = {
        link = {
          speed              = "10G"
          target_switch_name = "border_leaf"
          lag_mode = "lacp_active"
          tag_ids = [apstra_tag.host_tags["h9"].id]
        }
      }
    }
  }
}
