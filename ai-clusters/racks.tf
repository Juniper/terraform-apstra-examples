locals {
  leaf_definition_16x400_16x200 = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_16x200.id
    spine_link_count    = 1
    spine_link_speed    = "400G"
  }
  leaf_definition_16_16x400 = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16_16x400.id
    spine_link_count    = 1
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_32x200 = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count    = 1
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_32x200_2_spines = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count    = 2
    spine_link_speed    = "400G"
  }
  leaf_definition_32_32x400 = {
    logical_device_id   = apstra_logical_device.AI-Leaf_32_32x400.id
    spine_link_count    = 1
    spine_link_speed    = "400G"
  }
}

resource "apstra_rack_type" "AI_16xA100" {
  name                       = "AI 16xA100"
  description = "AI Rail-optimized A100 Rack Group of 16 Servers"
  fabric_connectivity_design = "l3clos"
  leaf_switches = { 
    Leaf1 = local.leaf_definition_16x400_16x200,
    Leaf2 = local.leaf_definition_16x400_16x200,
    Leaf3 = local.leaf_definition_16x400_16x200,
    Leaf4 = local.leaf_definition_16x400_16x200,
    Leaf5 = local.leaf_definition_16x400_16x200,
    Leaf6 = local.leaf_definition_16x400_16x200,
    Leaf7 = local.leaf_definition_16x400_16x200,
    Leaf8 = local.leaf_definition_16x400_16x200,
  }
  generic_systems = {
    DGX-A100 = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Server-A100_8x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf2"  
        },
        link3 = {
          speed              = "200G"
          target_switch_name = "Leaf3"  
        },
        link4 = {
          speed              = "200G"
          target_switch_name = "Leaf4"  
        },
        link5 = {
          speed              = "200G"
          target_switch_name = "Leaf5"  
        },
        link6 = {
          speed              = "200G"
          target_switch_name = "Leaf6"  
        },
        link7 = {
          speed              = "200G"
          target_switch_name = "Leaf7"  
        },
        link8 = {
          speed              = "200G"
          target_switch_name = "Leaf8"  
        },
      }
    }
  }
}


resource "apstra_rack_type" "AI_16xH100" {
  name                       = "AI 16xH100"
  description = "AI Rail-optimized H100 Rack Group of 16 Servers"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16_16x400,
    Leaf2 = local.leaf_definition_16_16x400,
    Leaf3 = local.leaf_definition_16_16x400,
    Leaf4 = local.leaf_definition_16_16x400,
    Leaf5 = local.leaf_definition_16_16x400,
    Leaf6 = local.leaf_definition_16_16x400,
    Leaf7 = local.leaf_definition_16_16x400,
    Leaf8 = local.leaf_definition_16_16x400,
  }
  generic_systems = {
    DGX-H100 = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Server-H100_8x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "400G"
          target_switch_name = "Leaf2"  
        },
        link3 = {
          speed              = "400G"
          target_switch_name = "Leaf3"  
        },
        link4 = {
          speed              = "400G"
          target_switch_name = "Leaf4"  
        },
        link5 = {
          speed              = "400G"
          target_switch_name = "Leaf5"  
        },
        link6 = {
          speed              = "400G"
          target_switch_name = "Leaf6"  
        },
        link7 = {
          speed              = "400G"
          target_switch_name = "Leaf7"  
        },
        link8 = {
          speed              = "400G"
          target_switch_name = "Leaf8"  
        },
      }
    }
  }
}

resource "apstra_rack_type" "AI_32xA100" {
  name                       = "AI 32xA100"
  description = "AI Rail-optimized A100 Rack Group of 32 Servers"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200,
    Leaf2 = local.leaf_definition_16x400_32x200,
    Leaf3 = local.leaf_definition_16x400_32x200,
    Leaf4 = local.leaf_definition_16x400_32x200,
    Leaf5 = local.leaf_definition_16x400_32x200,
    Leaf6 = local.leaf_definition_16x400_32x200,
    Leaf7 = local.leaf_definition_16x400_32x200,
    Leaf8 = local.leaf_definition_16x400_32x200,
  }
  generic_systems = {
    DGX-A100 = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Server-A100_8x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf2"  
        },
        link3 = {
          speed              = "200G"
          target_switch_name = "Leaf3"  
        },
        link4 = {
          speed              = "200G"
          target_switch_name = "Leaf4"  
        },
        link5 = {
          speed              = "200G"
          target_switch_name = "Leaf5"  
        },
        link6 = {
          speed              = "200G"
          target_switch_name = "Leaf6"  
        },
        link7 = {
          speed              = "200G"
          target_switch_name = "Leaf7"  
        },
        link8 = {
          speed              = "200G"
          target_switch_name = "Leaf8"  
        },
      }
    }
  }
}

resource "apstra_rack_type" "AI_32xA100_2_spine_uplinks" {
  name                       = "AI 32xA100 2sp"
  description = "AI Rail-optimized A100 Rack Group of 32 Servers (2 spine uplinks per leaf)"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf2 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf3 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf4 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf5 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf6 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf7 = local.leaf_definition_16x400_32x200_2_spines,
    Leaf8 = local.leaf_definition_16x400_32x200_2_spines,
  }
  generic_systems = {
    DGX-A100 = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Server-A100_8x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf2"  
        },
        link3 = {
          speed              = "200G"
          target_switch_name = "Leaf3"  
        },
        link4 = {
          speed              = "200G"
          target_switch_name = "Leaf4"  
        },
        link5 = {
          speed              = "200G"
          target_switch_name = "Leaf5"  
        },
        link6 = {
          speed              = "200G"
          target_switch_name = "Leaf6"  
        },
        link7 = {
          speed              = "200G"
          target_switch_name = "Leaf7"  
        },
        link8 = {
          speed              = "200G"
          target_switch_name = "Leaf8"  
        },
      }
    }
  }
}

resource "apstra_rack_type" "AI_32xH100" {
  name                       = "AI 32xH100"
  description = "AI Rail-optimized H100 Rack Group of 32 Servers"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_32_32x400,
    Leaf2 = local.leaf_definition_32_32x400,
    Leaf3 = local.leaf_definition_32_32x400,
    Leaf4 = local.leaf_definition_32_32x400,
    Leaf5 = local.leaf_definition_32_32x400,
    Leaf6 = local.leaf_definition_32_32x400,
    Leaf7 = local.leaf_definition_32_32x400,
    Leaf8 = local.leaf_definition_32_32x400,
  }
  generic_systems = {
    DGX-H100 = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Server-H100_8x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "400G"
          target_switch_name = "Leaf2"  
        },
        link3 = {
          speed              = "400G"
          target_switch_name = "Leaf3"  
        },
        link4 = {
          speed              = "400G"
          target_switch_name = "Leaf4"  
        },
        link5 = {
          speed              = "400G"
          target_switch_name = "Leaf5"  
        },
        link6 = {
          speed              = "400G"
          target_switch_name = "Leaf6"  
        },
        link7 = {
          speed              = "400G"
          target_switch_name = "Leaf7"  
        },
        link8 = {
          speed              = "400G"
          target_switch_name = "Leaf8"  
        },
      }
    }
  }
}
