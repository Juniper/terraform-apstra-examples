# Organization of this file:
#
# Design elements in sequence of LDs, then racks, then templates

# LD for the Juniper QFX5220 (aka Small leaf)
resource "apstra_logical_device" "ai_spine_32x400" {
  name = "AI-Spine 32x400"
  panels = [
    {
      rows    = 2
      columns = 16
      port_groups = [
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "ai_leaf_small_400" {
  name = "AI-Leaf Small 16x400 and 16x400"
  panels = [
    {
      rows    = 2
      columns = 16
      port_groups = [
        {
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        {
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "ai_leaf_small_200" {
  name = "AI-Leaf Small 16x400 and 32x200"
  panels = [
    {
      rows    = 2
      columns = 24
      port_groups = [
        {
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        {
          port_count = 32
          port_speed = "200G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

# The above racks are good for uniform stripes of A100 (200G) or H100 (400G) access (not both).
# They're also used for storage racks with uniform server ports.
# The JVD example will mix 4 A100 servers and 2 H100 servers in the same stripe, so we will
# divide the access ports to half 200 half 400. No oversubscription (spine uplinks) will
#  be based on the actual number of servers in use in the rack
resource "apstra_logical_device" "ai_lab_leaf_small" {
  name = "AI-LabLeaf Small 16x400, 16x200 and 8x400"
  panels = [
    {
      rows    = 4
      columns = 10
      port_groups = [
        {
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        { #A100 facing
          port_count = 16
          port_speed = "200G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        { #H100 facing
          port_count = 8
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

# For frontend 100G access
resource "apstra_logical_device" "ai_leaf_16x400_64x100" {
  name = "AI-Leaf Front 16x400G and 64x100G"
  panels = [
    {
      rows    = 2
      columns = 40
      port_groups = [
        {
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        {
          port_count = 64
          port_speed = "100G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

# LD for the Juniper QFX5230 (aka Medium leaf)
resource "apstra_logical_device" "ai_spine_64x400" {
  name = "AI-Spine 64x400"
  panels = [
    {
      rows    = 4
      columns = 16
      port_groups = [
        {
          port_count = 64
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "ai_leaf_medium_32" {
  name = "AI-Leaf Medium 32x400 and 32x200"
  panels = [
    {
      rows    = 4
      columns = 16
      port_groups = [
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "ai_leaf_medium_64" {
  name = "AI-Leaf Medium 32x400 and 64x200"
  panels = [
    {
      rows    = 4
      columns = 24
      port_groups = [
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        {
          port_count = 64
          port_speed = "200G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

# The above racks are good for uniform stripes of A100 (200G) or H100 (400G) access (not both).
# The JVD example will mix 4 A100 servers and 2 H100 servers in the same stripe, so we will
# divide the access ports to half 200 half 400. No oversubscription (spine uplinks) will
#  be based on the actual number of servers in use in the rack
resource "apstra_logical_device" "ai_lab_leaf_medium" {
  name = "AI-LabLeaf Medium 32x400, 32x200 and 16x400"
  panels = [
    {
      rows    = 4
      columns = 20
      port_groups = [
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        { #A100 facing
          port_count = 32
          port_speed = "200G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        { #H100 facing
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

#
# The PTX will be used for the large template size due to expandable modular chassis
# Here we use the 8-line card example
#
# LD for the Juniper PTX10000 line card of 36x400GE and PTX10008
# example with fully loaded chassis

locals {
  ptx_card_count = 2
  ptx_card_definition = {
    rows    = 2
    columns = 18
    port_groups = [
      {
        port_count = 36
        port_speed = "400G"
        port_roles = ["superspine", "spine", "leaf", "unused", "generic"]
      },
    ]
  }
}

resource "apstra_logical_device" "ai_spine_288x400" {
  name   = "AI-Spine 288x400"
  panels = [for i in range(local.ptx_card_count) : local.ptx_card_definition]
}

# LD for the Juniper PTX10000 line card of 36x400GE and PTX10008
# example with 2 line cards which is used in actual tested lab setup

locals {
  ptx_lab_card_count = 2
  ptx_lab_card_definition = {
    rows    = 2
    columns = 18
    port_groups = [
      {
        port_count = 36
        port_speed = "400G"
        port_roles = ["superspine", "spine", "leaf", "unused", "generic"]
      },
    ]
  }
}

resource "apstra_logical_device" "ai_spine_72x400" {
  name   = "AI-Spine 72x400"
  panels = [for i in range(local.ptx_lab_card_count) : local.ptx_lab_card_definition]
}


# Server LDs

# Lambda Labs Hyperplane8-A100
#
# Standard networking: 1x NVIDIA ConnectX-6 Dx adapter card, 100GbE, dual-port QSFP28, AIOM PCIe 4.0 x16
# Storage Networking: 1x 200 GbE NVIDIA ConnectX-6 VPI NIC: Dual-port QSFP56
# GPUDirect RDMA Networking: 8x NVIDIA ConnectX-7 Adapter Card 200GbE Single-port QSFP PCIe 4.0 x16

resource "apstra_logical_device" "a100_mgmt_1x100g" {
  name = "A100 Server Mgmt 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "a100_storage_1x200g" {
  name = "A100 Server Storage 1x200G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "200G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "a100_gpu_8x200g" {
  name = "A100 Server GPU 8x200G"
  panels = [
    {
      rows    = 2
      columns = 4
      port_groups = [
        {
          port_count = 8
          port_speed = "200G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

# NVIDIA DGX H100
#
# Standard networking: 1x 100 Gb/s Ethernet
# Storage Networking: 2x QSPF112 400 Gb/s InfiniBand/Ethernet, 
# GPUDirect RDMA Networking: 4x OSFP ports serving 8x single-port NVIDIA ConnectX-7 VPI 400 Gb/s InfiniBand/Ethernet

resource "apstra_logical_device" "h100_mgmt_1x100g" {
  name = "H100 Server Mgmt 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "h100_storage_2x400g" {
  name = "H100 Server Storage 2x400G"
  panels = [
    {
      rows    = 1
      columns = 2
      port_groups = [
        {
          port_count = 2
          port_speed = "400G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "h100-gpu_8x400g" {
  name = "H100 Server GPU 8x200G"
  panels = [
    {
      rows    = 2
      columns = 4
      port_groups = [
        {
          port_count = 8
          port_speed = "400G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}


# Weka Server Storage Nodes
#
# Standard networking: 1x NVIDIA ConnectX-6 Dx adapter card, 100GbE, dual-port QSFP28, PCIe 4.0 x16
# Storage Networking: 2x NVIDIA ConnectX-6 VPI adapter card, 200GbE, dual-port QSFP56, OCP 3.0

resource "apstra_logical_device" "weka_mgmt_1x100g" {
  name = "Weka Server Mgmt 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "weka-storage_2x200g" {
  name = "Weka Server Storage 2x200G"
  panels = [
    {
      rows    = 1
      columns = 2
      port_groups = [
        {
          port_count = 2
          port_speed = "200G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}



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
    tag_ids = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_small"].id]
  }
  backend_rack_leaf_definition_2 = {
    logical_device_id = apstra_logical_device.ai_lab_leaf_medium.id # with 5230
    spine_link_count  = 2
    spine_link_speed  = "400G"
    tag_ids = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_medium"].id]
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
        tag_ids = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_h100"].id, apstra_tag.host_tags["gpu_small"].id]
      } }
    },
    hgx_a100 = {
      count             = 4
      logical_device_id = apstra_logical_device.a100_gpu_8x200g.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_a100"].id, apstra_tag.host_tags["gpu_small"].id]
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
        tag_ids = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_h100"].id, apstra_tag.host_tags["gpu_medium"].id]
      } }
    },
    hgx_a100 = {
      count             = 4
      logical_device_id = apstra_logical_device.a100_gpu_8x200g.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids = [apstra_tag.host_tags["gpu"].id, apstra_tag.host_tags["gpu_a100"].id, apstra_tag.host_tags["gpu_medium"].id]
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
    tag_ids = [apstra_tag.host_tags["storage"].id]
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
          tag_ids = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_h100"].id]

        },
        link2 = {
          speed              = "400G"
          target_switch_name = "Leaf2"
          tag_ids = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_h100"].id]
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
          tag_ids = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_a100"].id]
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
          tag_ids = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_a100"].id]
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
    tag_ids = [apstra_tag.host_tags["storage"].id]
  }
}

resource "apstra_rack_type" "storage_weka" {
  name                       = "Storage-Weka"
  description                = "Rack of the Weka server storage ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.storage_weka_rack_leaf_count) : "Leaf${i + 1}" => local.storage_weka_rack_leaf_definition }
  generic_systems = {
    weka-storage = {
      count             = 8
      logical_device_id = apstra_logical_device.weka-storage_2x200g.id
      links = { for i in range(local.storage_weka_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
        tag_ids = [apstra_tag.host_tags["storage"].id, apstra_tag.host_tags["storage_weka"].id]
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
    tag_ids = [apstra_tag.host_tags["frontend"].id]
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
          tag_ids = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_a100"].id]
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
          tag_ids = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_h100"].id]
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
          tag_ids = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_headend"].id]
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
    weka-storage = {
      count             = 8
      logical_device_id = apstra_logical_device.weka_mgmt_1x100g.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
          tag_ids = [apstra_tag.host_tags["frontend"].id, apstra_tag.host_tags["frontend_weka"].id]
        },
      }
    }
  }
}


#
# TEMPLATES
# (for fabrics: GPU compute, storage, frontend mgmt)
#

# Large fabrics should use PTX high-radix modular chassic spines
# Here we use PTX10008 (288x400G)
# Smaller could be fewer line card per chassis (room to grow) or PTX10004
# Larger could be PTX10016 or (future) 800G line cards
# Adjust racks as needed for scale. This example is with one stripe of 5220s and one of 5230s

resource "apstra_template_rack_based" "ai_cluster_gpus_large" {
  name                     = "AI Cluster GPU Fabric - Large"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_72x400.id
  }
  rack_infos = {
    (apstra_rack_type.gpu_backend_sml.id) = { count = 1 }
    (apstra_rack_type.gpu_backend_med.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_72x400,
      apstra_rack_type.gpu_backend_sml,
      apstra_rack_type.gpu_backend_med,
    ]
  }
}

# Small-Medium fabrics can optionally use QFX spines
# Here we will use 5230 (64x400G)
# Smaller would be 5220 (32x400G), and (future) larger 5240 (64x800G)
# Adjust racks as needed for scale. This example is with one stripe of 5220s and one of 5230s

resource "apstra_template_rack_based" "ai_cluster_gpus_medium" {
  name                     = "AI Cluster GPU Fabric - Medium"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_64x400.id
  }
  rack_infos = {
    (apstra_rack_type.gpu_backend_sml.id) = { count = 1 }
    (apstra_rack_type.gpu_backend_med.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_64x400,
      apstra_rack_type.gpu_backend_sml,
      apstra_rack_type.gpu_backend_med,
    ]
  }
}

resource "apstra_template_rack_based" "ai_cluster_storage" {
  name                     = "AI Cluster Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.storage_ai.id)   = { count = 1 }
    (apstra_rack_type.storage_weka.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_32x400,
      apstra_rack_type.storage_ai,
      apstra_rack_type.storage_weka,
    ]
  }
}

resource "apstra_template_rack_based" "ai_cluster_mgmt" {
  name                     = "AI Cluster Management Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.frontend_mgmt_ai.id)   = { count = 1 }
    (apstra_rack_type.frontend_mgmt_weka.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_32x400,
      apstra_rack_type.frontend_mgmt_ai,
      apstra_rack_type.frontend_mgmt_weka,
    ]
  }
}
