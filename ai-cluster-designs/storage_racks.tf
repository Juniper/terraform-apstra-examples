
# Locals
#
# In all stoarge fabrics we will assume only one port per DGX
#
# 16x400_32x200_8spine_links is for the 512 A100 GPU storage fabric to DGX and storage nodes
#
# 16x400_16x400_4spine_links is for the 512 H100 GPU storage fabric to DGX servers
# 16x400_32x200_4spine_links is for the same but the storage node fabric
#
locals {
  leaf_definition_16x400_32x200_8spine_links = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count    = 8
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_32x200_4spine_links = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count    = 4
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_32x200_2spine_links = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count    = 2
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_32x200_1spine_link = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count    = 1
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_16x400_4spine_links = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16_16x400.id
    spine_link_count    = 4
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_16x400_2spine_links = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16_16x400.id
    spine_link_count    = 2
    spine_link_speed    = "400G"
  }
  leaf_definition_16x400_16x400_1spine_link = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16_16x400.id
    spine_link_count    = 1
    spine_link_speed    = "400G"
  }
}

# Storage rack of 200GE access to DGX A100 servers with 1x200G storage port
resource "apstra_rack_type" "AI_strg_32_1x200G_8spine_links" {
  name                       = "AI strg32 1x200-8"
  description = "AI storage rack for 1x200GE connectivity for 32 DGX A100 servers. 8 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_8spine_links,
  }
  generic_systems = {
    DGX_Storage = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Storage_1x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 200GE access to DGX A100 servers with 2x200G storage ports
# (unused in our use cases of fabrics with single port connectivity)
resource "apstra_rack_type" "AI_strg_16_2x200G_8spine_links" {
  name                       = "AI strg16 2x200-8"
  description = "AI storage rack for 2x200GE connectivity for 16 DGX A100 servers. 8 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_8spine_links,
  }
  generic_systems = {
    DGX_Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage_2x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 200GE access to DGX A100 servers with 1x200G storage port
resource "apstra_rack_type" "AI_strg_32_1x200G_4spine_links" {
  name                       = "AI strg32 1x200-4"
  description = "AI storage rack for 1x200GE connectivity for 32 DGX A100 servers. 4 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_4spine_links,
  }
  generic_systems = {
    DGX_Storage = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Storage_1x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 200GE access to DGX A100 servers with 1x200G storage port
resource "apstra_rack_type" "AI_strg_32_1x200G_2spine_links" {
  name                       = "AI strg32 1x200-2"
  description = "AI storage rack for 1x200GE connectivity for 32 DGX A100 servers. 2 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_2spine_links,
  }
  generic_systems = {
    DGX_Storage = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Storage_1x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 400GE access to DGX H100 servers with 1x400G storage port
resource "apstra_rack_type" "AI_strg_16_1x400G_4spine_links" {
  name                       = "AI strg16 1x400-4"
  description = "AI storage rack for 1x400GE connectivity for 16 DGX H100 servers. 4 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_16x400_4spine_links,
  }
  generic_systems = {
    DGX-H100-Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage_1x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 400GE access to DGX H100 servers with 2x400G storage ports
# (unused in our use cases of fabrics with single port connectivity)
resource "apstra_rack_type" "AI_strg_8_2x400G_4spine_links" {
  name                       = "AI strg16 2x400-4"
  description = "AI storage rack for 2x400GE connectivity for 16 DGX H100 servers. 4 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_16x400_4spine_links,
  }
  generic_systems = {
    DGX_Storage = {
      count             = 8
      logical_device_id = apstra_logical_device.AI-Storage_2x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 400GE access to DGX H100 servers with 1x400G storage port
resource "apstra_rack_type" "AI_strg_16_1x400G_2spine_links" {
  name                       = "AI strg16 1x400-2"
  description = "AI storage rack for 1x400GE connectivity for 16 DGX H100 servers. 2 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_16x400_2spine_links,
  }
  generic_systems = {
    DGX-H100-Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage_1x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 400GE access to DGX H100 servers with 1x400G storage port
resource "apstra_rack_type" "AI_strg_16_1x400G_1spine_link" {
  name                       = "AI strg16 1x400-1"
  description = "AI storage rack for 1x400GE connectivity for 16 DGX H100 servers. 1 spine link"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_16x400_1spine_link,
  }
  generic_systems = {
    DGX-H100-Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage_1x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}


# Storage rack of 200GE access to Weka servers with 2x200G storage ports
# 8 spine links used for the 512 A100 GPU fabric use case
resource "apstra_rack_type" "AI_weka_16_2x200G_8spine_links" {
  name                       = "AI weka16 2x200-8"
  description = "Weka storage node rack for 2x200GE connectivity per node. 8 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_8spine_links,
  }
  generic_systems = {
    Weka_Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage-Weka_2x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}


# Storage rack of 200GE access to Weka servers with 2x200G storage ports
# 4 spine links used for the 512 H100 GPU fabric use case
resource "apstra_rack_type" "AI_weka_16_2x200G_4spine_links" {
  name                       = "AI weka16 2x200-4"
  description = "Weka storage node rack for 2x200GE connectivity per node. 4 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_4spine_links,
  }
  generic_systems = {
    Weka_Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage-Weka_2x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 200GE access to Weka servers with 2x200G storage ports
# 2 spine links used for the 1024 H100 GPU fabric use case
resource "apstra_rack_type" "AI_weka_16_2x200G_2spine_links" {
  name                       = "AI weka16 2x200-2"
  description = "Weka storage node rack for 2x200GE connectivity per node. 2 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_2spine_links,
  }
  generic_systems = {
    Weka_Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage-Weka_2x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}

# Storage rack of 200GE access to Weka servers with 2x200G storage ports
# 1 spine link used for the 2048 H100 GPU fabric use case
resource "apstra_rack_type" "AI_weka_16_2x200G_1spine_link" {
  name                       = "AI weka16 2x200-1"
  description = "Weka storage node rack for 2x200GE connectivity per node. 1 spine link"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x200_1spine_link,
  }
  generic_systems = {
    Weka_Storage = {
      count             = 16
      logical_device_id = apstra_logical_device.AI-Storage-Weka_2x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
        link2 = {
          speed              = "200G"
          target_switch_name = "Leaf1"  
        },
      }
    }
  }
}