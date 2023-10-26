#
# RACKS
#

# Rack for the GPU Compute backend fabric
#
# Populated with 4 A100-based servers and 2 H100-based servers, each leaf has
# 4x200G + 2x400G
# 2x400G spine uplinks (to 2 spines) to achieve 1:1 (no) oversubscription

locals {
  backend_rack_leaf_count = 8
  backend_rack_leaf_definition_1 = {
    logical_device_id = apstra_logical_device.ai_lab_leaf_small.id # with 5220
    spine_link_count  = 2
    spine_link_speed  = "400G"
    tag_ids           = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_small"].id]
  }

  backend_rack_leaf_definition_2 = {
    logical_device_id = apstra_logical_device.ai_lab_leaf_medium.id # with 5230
    spine_link_count  = 2
    spine_link_speed  = "400G"
    tag_ids           = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_medium"].id]
  }
}

#
# Small rack/stripe uses the 5220 (32x400) switch
#
resource "apstra_rack_type" "gpu_backend_sml" {
  name                       = "GPU-Backend-Sml"
  description                = "AI Rail-optimized Rack Group of up to 16 H100-based or 32 A100-based Servers. 2 spine uplinks"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.backend_rack_leaf_count) : "Leaf${i + 1}" => local.backend_rack_leaf_definition_1 }
  generic_systems = {
    dgx_h100 = {
      count             = 2
      logical_device_id = apstra_logical_device.h100-gpu_8x400g.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "400G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids            = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_h100"].id, apstra_tag.host_tags["gpu_small"].id]
      } }
    },
    hgx_a100 = {
      count             = 4
      logical_device_id = apstra_logical_device.a100_gpu_8x200g.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids            = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_a100"].id, apstra_tag.host_tags["gpu_small"].id]
      } }
    }
  }
}

#
# Medium rack/stripe uses the 5230 (64x400) switch
#
resource "apstra_rack_type" "gpu_backend_med" {
  name                       = "GPU-Backend-Med"
  description                = "AI Rail-optimized Rack Group of up to 32 H100-based or 64 A100-based Servers. 2 spine uplinks"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.backend_rack_leaf_count) : "Leaf${i + 1}" => local.backend_rack_leaf_definition_2 }
  generic_systems = {
    dgx_h100 = {
      count             = 2
      logical_device_id = apstra_logical_device.h100-gpu_8x400g.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "400G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids            = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_h100"].id, apstra_tag.host_tags["gpu_medium"].id]
      } }
    },
    hgx_a100 = {
      count             = 4
      logical_device_id = apstra_logical_device.a100_gpu_8x200g.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids            = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_a100"].id, apstra_tag.host_tags["gpu_medium"].id]
      } }
    }
  }
}



# Rack for the HGX and DGX Storage Ports
#
# We are basing spine uplinks to achieve 1:1 (no) oversubscription
# based on the 4x400G access links from the H100 servers.
#
# The 4 DGX-H100 servers have 2 storage ports and we will home those
# to two separate leafs. The 8 HGX-A100 servers have only one storage port
# and we will connect 4 to each leaf

locals {
  storage_rack_leaf_count = 2
  storage_rack_leaf_definition = {
    logical_device_id = apstra_logical_device.ai_leaf_small_200.id
    spine_link_count  = 3
    spine_link_speed  = "400G"
    tag_ids           = [apstra_tag.host_tags["storage"].id]
  }
}


resource "apstra_rack_type" "storage_ai" {
  name                       = "Storage-Ports-AI"
  description                = "Rack of the HGX and DGX storage ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.storage_rack_leaf_count) : "Leaf${i + 1}" => local.storage_rack_leaf_definition }
  generic_systems = {
    dgx-h100-storage = {
      count             = 4
      logical_device_id = apstra_logical_device.h100_storage_2x400g.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"
          tag_ids            = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_h100"].id]

        },
        link2 = {
          speed              = "400G"
          target_switch_name = "Leaf2"
          tag_ids            = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_h100"].id]
        },
      }
    },
    hgx-a100-storage-1 = {
      count             = 4
      logical_device_id = apstra_logical_device.a100_storage_1x200g.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"
          tag_ids            = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_a100"].id]
        },
      }
    },
    hgx-a100-storage-2 = {
      count             = 4
      logical_device_id = apstra_logical_device.a100_storage_1x200g.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf2"
          tag_ids            = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_a100"].id]
        },
      }
    }
  }
}


# Rack for the Weka Server Storage Ports
# (will be in the same template/fabric as the AI server storage ports)
#
# We are basing spine uplinks 2x400 to two spines) to achieve 1:1 (no)
# oversubscription based on the 8x200G access links from the Weka servers.
#
# We're homing the servers to two switches for redundancy
#

locals {
  storage_weka_rack_leaf_count = 2
  storage_weka_rack_leaf_definition = {
    logical_device_id = apstra_logical_device.ai_leaf_small_200.id # with 5220
    spine_link_count  = 2
    spine_link_speed  = "400G"
    tag_ids           = [apstra_tag.host_tags["storage"].id]
  }
}

resource "apstra_rack_type" "storage_weka" {
  name                       = "Storage-Weka"
  description                = "Rack of the Weka server storage ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.storage_weka_rack_leaf_count) : "Leaf${i + 1}" => local.storage_weka_rack_leaf_definition }
  generic_systems = {
    weka_storage = {
      count             = 8
      logical_device_id = apstra_logical_device.weka_storage_2x200g.id
      links = { for i in range(local.storage_weka_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids            = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_weka"].id]
      } }
    }
  }
}

#
# Rack for the management ports from the HGX and DGX servers
#

locals {
  frontend_leaf_definition = {
    logical_device_id = apstra_logical_device.ai_leaf_16x400_64x100.id
    spine_link_count  = 2
    spine_link_speed  = "400G"
    tag_ids           = [apstra_tag.host_tags["frontend"].id]
  }
}

resource "apstra_rack_type" "frontend_mgmt_ai" {
  name                       = "Frontend-AI"
  description                = "Rack of the AI server management ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.frontend_leaf_definition,
  }
  generic_systems = {
    hgx-mgmt = {
      count             = 8
      logical_device_id = apstra_logical_device.a100_mgmt_1x100g.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
          tag_ids            = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_a100"].id]
        },
      }
    },
    dgx-mgmt = {
      count             = 4
      logical_device_id = apstra_logical_device.h100_mgmt_1x100g.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
          tag_ids            = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_h100"].id]
        },
      }
    },
    headend_servers = {
      count             = 3
      logical_device_id = "AOS-1x100-1"
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
          tag_ids            = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_headend"].id]
        }
      }
    },
  }
}

#
# Rack for the management ports from the Weka servers
#

resource "apstra_rack_type" "frontend_mgmt_weka" {
  name                       = "Frontend-Weka"
  description                = "Rack of the Weka server management ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.frontend_leaf_definition,
  }
  generic_systems = {
    weka_storage = {
      count             = 8
      logical_device_id = apstra_logical_device.weka_mgmt_1x100g.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
          tag_ids            = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_weka"].id]
        },
      }
    }
  }
}

