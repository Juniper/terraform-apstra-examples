# Organization of this file:
#
# Design elements in sequence of LDs, then racks, then templates, then interface maps

# LD for the Juniper QFX5220 (aka Small leaf)
resource "apstra_logical_device" "AI-Spine_32x400" {
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

resource "apstra_logical_device" "AI-Leaf_Small_400" {
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

resource "apstra_logical_device" "AI-Leaf_Small_200" {
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
resource "apstra_logical_device" "AI-LabLeaf_Small" {
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
resource "apstra_logical_device" "AI-Leaf_16x400_64x100" {
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
resource "apstra_logical_device" "AI-Spine_64x400" {
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

resource "apstra_logical_device" "AI-Leaf_Medium_32" {
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

resource "apstra_logical_device" "AI-Leaf_Medium_64" {
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
resource "apstra_logical_device" "AI-LabLeaf_Medium" {
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


# LD for the Juniper PTX10000 line card of 36x400GE and 10008
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

resource "apstra_logical_device" "AI-Spine_288x400" {
  name   = "AI-Spine 288x400"
  panels = [for i in range(local.ptx_card_count) : local.ptx_card_definition]
}


# Server LDs

# Lambda Labs Hyperplane8-A100
#
# Standard networking: 1x NVIDIA ConnectX-6 Dx adapter card, 100GbE, dual-port QSFP28, AIOM PCIe 4.0 x16
# Storage Networking: 1x 200 GbE NVIDIA ConnectX-6 VPI NIC: Dual-port QSFP56
# GPUDirect RDMA Networking: 8x NVIDIA ConnectX-7 Adapter Card 200GbE Single-port QSFP PCIe 4.0 x16

resource "apstra_logical_device" "A100-Mgmt_1x100G" {
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

resource "apstra_logical_device" "A100-Storage_1x200G" {
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

resource "apstra_logical_device" "A100-GPU_8x200G" {
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

resource "apstra_logical_device" "H100-Mgmt_1x100G" {
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

resource "apstra_logical_device" "H100-Storage_2x400G" {
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

resource "apstra_logical_device" "H100-GPU_8x400G" {
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

resource "apstra_logical_device" "Weka-Mgmt_1x100G" {
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

resource "apstra_logical_device" "Weka-Storage_2x200G" {
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
    logical_device_id = apstra_logical_device.AI-LabLeaf_Small.id # with 5220
    spine_link_count  = 2
    spine_link_speed  = "400G"
  }
  backend_rack_leaf_definition_2 = {
    logical_device_id = apstra_logical_device.AI-LabLeaf_Medium.id # with 5230
    spine_link_count  = 2
    spine_link_speed  = "400G"
  }
}

#
# Small rack/stripe uses the 5220 (32x400) switch
#
resource "apstra_rack_type" "GPU-Backend_Sml" {
  name                       = "GPU-Backend-Sml"
  description                = "AI Rail-optimized Rack Group of up to 16 H100-based or 32 A100-based Servers. 2 spine uplinks"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.backend_rack_leaf_count) : "Leaf${i + 1}" => local.backend_rack_leaf_definition_1 }
  generic_systems = {
    DGX-H100 = {
      count             = 2
      logical_device_id = apstra_logical_device.H100-GPU_8x400G.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "400G"
        target_switch_name = "Leaf${i + 1}"
      } }
    },
    HGX-A100 = {
      count             = 4
      logical_device_id = apstra_logical_device.A100-GPU_8x200G.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
      } }
    }
  }
}

#
# Medium rack/stripe uses the 5230 (64x400) switch
#
resource "apstra_rack_type" "GPU-Backend_Med" {
  name                       = "GPU-Backend-Med"
  description                = "AI Rail-optimized Rack Group of up to 32 H100-based or 64 A100-based Servers. 2 spine uplinks"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.backend_rack_leaf_count) : "Leaf${i + 1}" => local.backend_rack_leaf_definition_2 }
  generic_systems = {
    DGX-H100 = {
      count             = 2
      logical_device_id = apstra_logical_device.H100-GPU_8x400G.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "400G"
        target_switch_name = "Leaf${i + 1}"
      } }
    },
    HGX-A100 = {
      count             = 4
      logical_device_id = apstra_logical_device.A100-GPU_8x200G.id
      links = { for i in range(local.backend_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
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
    logical_device_id = apstra_logical_device.AI-Leaf_Small_200.id
    spine_link_count  = 3
    spine_link_speed  = "400G"
  }
}


resource "apstra_rack_type" "Storage-AI" {
  name                       = "Storage-Ports-AI"
  description                = "Rack of the HGX and DGX storage ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.storage_rack_leaf_count) : "Leaf${i + 1}" => local.storage_rack_leaf_definition }
  generic_systems = {
    DGX-H100-Storage = {
      count             = 4
      logical_device_id = apstra_logical_device.H100-Storage_2x400G.id
      links = {
        link1 = {
          speed              = "400G"
          target_switch_name = "Leaf1"
        },
        link2 = {
          speed              = "400G"
          target_switch_name = "Leaf2"
        },
      }
    },
    HGX-A100-Storage-1 = {
      count             = 4
      logical_device_id = apstra_logical_device.A100-Storage_1x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf1"
        },
      }
    },
    HGX-A100-Storage-2 = {
      count             = 4
      logical_device_id = apstra_logical_device.A100-Storage_1x200G.id
      links = {
        link1 = {
          speed              = "200G"
          target_switch_name = "Leaf2"
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
  storage_weka_rack_leaf_count      = 2
  storage_weka_rack_leaf_definition = {
    logical_device_id = apstra_logical_device.AI-Leaf_Small_200.id # with 5220
    spine_link_count  = 2
    spine_link_speed  = "400G"
  }
}

resource "apstra_rack_type" "Storage-Weka" {
  name                       = "Storage-Weka"
  description                = "Rack of the Weka server storage ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.storage_weka_rack_leaf_count) : "Leaf${i + 1}" => local.storage_weka_rack_leaf_definition }
  generic_systems = {
    Weka-Storage = {
      count             = 8
      logical_device_id = apstra_logical_device.Weka-Storage_2x200G.id
      links = { for i in range(local.storage_weka_rack_leaf_count) : "link${i + 1}" => {
        speed              = "200G"
        target_switch_name = "Leaf${i + 1}"
      } }
    }
  }
}

#
# Rack for the management ports from the HGX and DGX servers
#

locals {
  frontend_leaf_definition = {
    logical_device_id = apstra_logical_device.AI-Leaf_16x400_64x100.id
    spine_link_count  = 2
    spine_link_speed  = "400G"
  }
}

resource "apstra_rack_type" "Frontend-Mgmt-AI" {
  name                       = "Frontend-AI"
  description                = "Rack of the AI server management ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.frontend_leaf_definition,
  }
  generic_systems = {
    HGX-Mgmt = {
      count             = 8
      logical_device_id = apstra_logical_device.A100-Mgmt_1x100G.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
        },
      }
    },
    DGX-Mgmt = {
      count             = 4
      logical_device_id = apstra_logical_device.H100-Mgmt_1x100G.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
        },
      }
    },
  }
}

#
# Rack for the management ports from the Weka servers
#

resource "apstra_rack_type" "Frontend-Mgmt-Weka" {
  name                       = "Frontend-Weka"
  description                = "Rack of the Weka server management ports"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.frontend_leaf_definition,
  }
  generic_systems = {
    Weka-Storage = {
      count             = 8
      logical_device_id = apstra_logical_device.Weka-Mgmt_1x100G.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
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
resource "apstra_template_rack_based" "AI_Cluster_GPUs_Large" {
  name                     = "AI Cluster GPU Fabric - Large"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_288x400.id
  }
  rack_infos = {
    (apstra_rack_type.GPU-Backend_Sml.id) = { count = 1 }
    (apstra_rack_type.GPU-Backend_Med.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.AI-Spine_288x400,
      apstra_rack_type.GPU-Backend_Sml,
      apstra_rack_type.GPU-Backend_Med,
    ]
  }
}

# Small-Medium fabrics can optionally use QFX spines
# Here we will use 5230 (64x400G)
# Smaller would be 5220 (32x400G), and (future) larger 5240 (64x800G)
# Adjust racks as needed for scale. This example is with one stripe of 5220s and one of 5230s
resource "apstra_template_rack_based" "AI_Cluster_GPUs_Medium" {
  name                     = "AI Cluster GPU Fabric - Medium"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_64x400.id
  }
  rack_infos = {
    (apstra_rack_type.GPU-Backend_Sml.id) = { count = 1 }
    (apstra_rack_type.GPU-Backend_Med.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.AI-Spine_64x400,
      apstra_rack_type.GPU-Backend_Sml,
      apstra_rack_type.GPU-Backend_Med,
    ]
  }
}

resource "apstra_template_rack_based" "AI_Cluster_Storage" {
  name                     = "AI Cluster Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.Storage-AI.id)   = { count = 1 }
    (apstra_rack_type.Storage-Weka.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.AI-Spine_32x400,
      apstra_rack_type.Storage-AI,
      apstra_rack_type.Storage-Weka,
    ]
  }
}

resource "apstra_template_rack_based" "AI_Cluster_Mgmt" {
  name                     = "AI Cluster Management Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.Frontend-Mgmt-AI.id)   = { count = 1 }
    (apstra_rack_type.Frontend-Mgmt-Weka.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.AI-Spine_32x400,
      apstra_rack_type.Frontend-Mgmt-AI,
      apstra_rack_type.Frontend-Mgmt-Weka,
    ]
  }
}

#
# INTERFACE MAPS
#


locals {
  ai_leaf_small_200_spine_port_count    = apstra_logical_device.AI-LabLeaf_Small.panels[0].port_groups[0].port_count // the 400G "spine" port group has a count of 16
  ai_leaf_small_200_spine_ld_port_first = 1                                                                          // first logical device "spine" port is 1/1
  ai_leaf_small_200_spine_dp_port_first = 0                                                                          // first physical device "spine" port is et-0/0/0

  ai_leaf_small_200_server_port_count    = apstra_logical_device.AI-LabLeaf_Small.panels[0].port_groups[1].port_count              // the 200G "server" port group has a count of 16
  ai_leaf_small_200_server_ld_port_first = local.ai_leaf_small_200_spine_ld_port_first + local.ai_leaf_small_200_spine_port_count  // first logical device "server" port is 1/17
  ai_leaf_small_200_server_dp_port_first = local.ai_leaf_small_200_spine_dp_port_first + local.ai_leaf_small_200_spine_port_count  // first physical device "server" port is et-0/0/16

  ai_leaf_small_400_server_port_count    = apstra_logical_device.AI-LabLeaf_Small.panels[0].port_groups[2].port_count                // the 400G "server" port group has a count of 8
  ai_leaf_small_400_server_ld_port_first = local.ai_leaf_small_200_server_ld_port_first + local.ai_leaf_small_200_server_port_count  // first logical device "server" port is 1/33
  ai_leaf_small_400_server_dp_port_first = local.ai_leaf_small_200_server_dp_port_first + (local.ai_leaf_small_200_server_port_count/2)  // first physical device "server" port is et-0/0/24
}

resource "apstra_interface_map" "AI-LabLeaf_Small" {
  name              = "${apstra_logical_device.AI-LabLeaf_Small.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.AI-LabLeaf_Small.id
  device_profile_id = "Juniper_QFX5220-32CD_Junos"
  interfaces = flatten([
    // the spine ports
    [for i in range(local.ai_leaf_small_200_spine_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_small_200_spine_ld_port_first + i}"      // 1/1 through 1/16
        physical_interface_name = "et-0/0/${local.ai_leaf_small_200_spine_dp_port_first + i}" // et-0/0/0 through et-0/0/15
      }
    ],
    // the server ports at 200
    [for i in range(local.ai_leaf_small_200_server_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_small_200_server_ld_port_first + i}"                          // 1/17 through 1/48
        physical_interface_name = "et-0/0/${local.ai_leaf_small_200_server_dp_port_first + floor(i / 2)}:${i % 2}" // et-0/0/16:0 through et-0/0/23:1
      }
    ],
   // the server ports at 400
    [for i in range(local.ai_leaf_small_400_server_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_small_400_server_ld_port_first + i}"                 // 1/17 through 1/48
        physical_interface_name = "et-0/0/${local.ai_leaf_small_400_server_dp_port_first + i}" // et-0/0/24 through et-0/0/31
      }
    ],
  ])
}


locals {
  ai_leaf_medium_200_spine_port_count    = apstra_logical_device.AI-LabLeaf_Medium.panels[0].port_groups[0].port_count // the 400G "spine" port group has a count of 32
  ai_leaf_medium_200_spine_ld_port_first = 1                                                                          // first logical device "spine" port is 1/1
  ai_leaf_medium_200_spine_dp_port_first = 0                                                                          // first physical device "spine" port is et-0/0/0

  ai_leaf_medium_200_server_port_count    = apstra_logical_device.AI-LabLeaf_Medium.panels[0].port_groups[1].port_count              // the 200G "server" port group has a count of 32
  ai_leaf_medium_200_server_ld_port_first = local.ai_leaf_medium_200_spine_ld_port_first + local.ai_leaf_medium_200_spine_port_count  // first logical device "server" port is 1/33
  ai_leaf_medium_200_server_dp_port_first = local.ai_leaf_medium_200_spine_dp_port_first + local.ai_leaf_medium_200_spine_port_count  // first physical device "server" port is et-0/0/32

  ai_leaf_medium_400_server_port_count    = apstra_logical_device.AI-LabLeaf_Medium.panels[0].port_groups[2].port_count                // the 400G "server" port group has a count of 16
  ai_leaf_medium_400_server_ld_port_first = local.ai_leaf_medium_200_server_ld_port_first + local.ai_leaf_medium_200_server_port_count  // first logical device "server" port is 1/64
  ai_leaf_medium_400_server_dp_port_first = local.ai_leaf_medium_200_server_dp_port_first + (local.ai_leaf_medium_200_server_port_count/2)  // first physical device "server" port is et-0/0/48
}

resource "apstra_interface_map" "AI-LabLeaf_Medium" {
  name              = "${apstra_logical_device.AI-LabLeaf_Medium.name}__QFX5230-64CD"
  logical_device_id = apstra_logical_device.AI-LabLeaf_Medium.id
  device_profile_id = "Juniper_QFX5230-64CD_Junos"
  interfaces = flatten([
    // the spine ports
    [for i in range(local.ai_leaf_medium_200_spine_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_medium_200_spine_ld_port_first + i}"      // 1/1 through 1/32
        physical_interface_name = "et-0/0/${local.ai_leaf_medium_200_spine_dp_port_first + i}" // et-0/0/0 through et-0/0/31
      }
    ],
    // the server ports at 200
    [for i in range(local.ai_leaf_medium_200_server_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_medium_200_server_ld_port_first + i}"                          // 1/33 through 1/64
        physical_interface_name = "et-0/0/${local.ai_leaf_medium_200_server_dp_port_first + floor(i / 2)}:${i % 2}" // et-0/0/32:0 through et-0/0/47:1
      }
    ],
   // the server ports at 400
    [for i in range(local.ai_leaf_medium_400_server_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_medium_400_server_ld_port_first + i}"                 // 1/64 through 1/80
        physical_interface_name = "et-0/0/${local.ai_leaf_medium_400_server_dp_port_first + i}" // et-0/0/48 through et-0/0/63
      }
    ],
  ])
}


locals {
  ai_leaf_16x400_32x200_spine_port_count    = apstra_logical_device.AI-Leaf_Small_200.panels[0].port_groups[0].port_count // the "spine" port group has a count of 16
  ai_leaf_16x400_32x200_spine_ld_port_first = 1                                                                               // first logical device "spine" port is 1/1
  ai_leaf_16x400_32x200_spine_dp_port_first = 0                                                                               // first physical device "spine" port is et-0/0/0

  ai_leaf_16x400_32x200_server_port_count    = apstra_logical_device.AI-Leaf_Small_200.panels[0].port_groups[1].port_count                // the "server" port group has a count of 32
  ai_leaf_16x400_32x200_server_ld_port_first = local.ai_leaf_16x400_32x200_spine_ld_port_first + local.ai_leaf_16x400_32x200_spine_port_count // first logical device "server" port is 1/17
  ai_leaf_16x400_32x200_server_dp_port_first = local.ai_leaf_16x400_32x200_spine_dp_port_first + local.ai_leaf_16x400_32x200_spine_port_count // first physical device "server" port is et-0/0/16
}

resource "apstra_interface_map" "AI-Leaf_16x400_32x200" {
  name              = "${apstra_logical_device.AI-Leaf_Small_200.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.AI-Leaf_Small_200.id
  device_profile_id = "Juniper_QFX5220-32CD_Junos"
  interfaces = flatten([
    // the spine ports
    [for i in range(local.ai_leaf_16x400_32x200_spine_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_16x400_32x200_spine_ld_port_first + i}"      // 1/1 through 1/16
        physical_interface_name = "et-0/0/${local.ai_leaf_16x400_32x200_spine_dp_port_first + i}" // et-0/0/0 through et-0/0/15
      }
    ],
    // the server ports
    [for i in range(local.ai_leaf_16x400_32x200_server_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_16x400_32x200_server_ld_port_first + i}"                          // 1/17 through 1/48
        physical_interface_name = "et-0/0/${local.ai_leaf_16x400_32x200_server_dp_port_first + floor(i / 2)}:${i % 2}" // et-0/0/16:0 through et-0/0/31:1
      }
    ],
  ])
}


locals {
  ai_leaf_16x400_64x100_spine_port_count    = apstra_logical_device.AI-Leaf_16x400_64x100.panels[0].port_groups[0].port_count // the "spine" port group has a count of 16
  ai_leaf_16x400_64x100_spine_ld_port_first = 1                                                                               // first logical device "spine" port is 1/1
  ai_leaf_16x400_64x100_spine_dp_port_first = 0                                                                               // first physical device "spine" port is et-0/0/0

  ai_leaf_16x400_64x100_server_port_count    = apstra_logical_device.AI-Leaf_16x400_64x100.panels[0].port_groups[1].port_count                // the "server" port group has a count of 64
  ai_leaf_16x400_64x100_server_ld_port_first = local.ai_leaf_16x400_64x100_spine_ld_port_first + local.ai_leaf_16x400_64x100_spine_port_count // first logical device "server" port is 1/17
  ai_leaf_16x400_64x100_server_dp_port_first = local.ai_leaf_16x400_64x100_spine_dp_port_first + local.ai_leaf_16x400_64x100_spine_port_count // first physical device "server" port is et-0/0/16
}

resource "apstra_interface_map" "AI-Leaf_16x400_64x100" {
  name              = "${apstra_logical_device.AI-Leaf_16x400_64x100.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.AI-Leaf_16x400_64x100.id
  device_profile_id = "Juniper_QFX5220-32CD_Junos"
  interfaces = flatten([
    // the spine ports
    [for i in range(local.ai_leaf_16x400_64x100_spine_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_16x400_64x100_spine_ld_port_first + i}"      // 1/1 through 1/16
        physical_interface_name = "et-0/0/${local.ai_leaf_16x400_64x100_spine_dp_port_first + i}" // et-0/0/0 through et-0/0/15
      }
    ],
    // the server ports
    [for i in range(local.ai_leaf_16x400_64x100_server_port_count) :
      {
        logical_device_port     = "1/${local.ai_leaf_16x400_64x100_server_ld_port_first + i}"                          // 1/17 through 1/48
        physical_interface_name = "et-0/0/${local.ai_leaf_16x400_64x100_server_dp_port_first + floor(i / 4)}:${i % 4}" // et-0/0/16:0 through et-0/0/31:3
      }
    ],
  ])
}

locals {
  ai_spine_32x400_port_count    = apstra_logical_device.AI-Spine_32x400.panels[0].port_groups[0].port_count // the port group has a count of 32
  ai_spine_32x400_ld_port_first = 1                                                                         // first logical device "spine" port is 1/1
  ai_spine_32x400_dp_port_first = 0                                                                         // first physical device "spine" port is et-0/0/0
}

resource "apstra_interface_map" "AI-Spine_32x400" {
  name              = "${apstra_logical_device.AI-Spine_32x400.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  device_profile_id = "Juniper_QFX5220-32CD_Junos"
  interfaces = flatten([
    // the spine ports
    [for i in range(local.ai_spine_32x400_port_count) :
      {
        logical_device_port     = "1/${local.ai_spine_32x400_ld_port_first + i}"      // 1/1 through 1/32
        physical_interface_name = "et-0/0/${local.ai_spine_32x400_dp_port_first + i}" // et-0/0/0 through et-0/0/31
      }
    ],
  ])
}

locals {
  ai_spine_64x400_port_count    = apstra_logical_device.AI-Spine_64x400.panels[0].port_groups[0].port_count // the port group has a count of 64
  ai_spine_64x400_ld_port_first = 1                                                                         // first logical device "spine" port is 1/1
  ai_spine_64x400_dp_port_first = 0                                                                         // first physical device "spine" port is et-0/0/0
}

resource "apstra_interface_map" "AI-Spine_64x400" {
  name              = "${apstra_logical_device.AI-Spine_64x400.name}__QFX5230-64CD"
  logical_device_id = apstra_logical_device.AI-Spine_64x400.id
  device_profile_id = "Juniper_QFX5230-64CD_Junos"
  interfaces = flatten([
    // the spine ports
    [for i in range(local.ai_spine_64x400_port_count) :
      {
        logical_device_port     = "1/${local.ai_spine_64x400_ld_port_first + i}"      // 1/1 through 1/64
        physical_interface_name = "et-0/0/${local.ai_spine_64x400_dp_port_first + i}" // et-0/0/0 through et-0/0/63
      }
    ],
  ])
}
