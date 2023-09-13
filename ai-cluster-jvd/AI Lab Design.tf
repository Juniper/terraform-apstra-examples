# Organization of this file:
#
# Design elements in sequence of LDs, then racks, then templates

# LD for the Juniper QFX5220
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

resource "apstra_logical_device" "AI-Leaf_16x400_32x200" {
  name = "AI-Leaf 24x400 and 16x200"
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

resource "apstra_logical_device" "AI-Leaf_16x400_64x100" {
  name = "AI-Leaf 16x400G 64x100G "
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
# Storage Networking: 1x 200 Gbps NVIDIA ConnectX-6 VPI NIC: Dual-port QSFP56, HDR InfiniBand/Ethernet#
# GPUDirect RDMA Networking: 8x NVIDIA ConnectX-7 Adapter Card 200Gb/s NDR200 IB Single-port OSFP PCIe 4.0 x16

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
# Storage Networking: 2x NVIDIA ConnectX-6 VPI adapter card, HDR IB (200Gb/s) and 200GbE, dual-port QSFP56, OCP 3.0

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
# 4x200G + 2x400G but tests will use only A100 or H100 initially, so we use
# 2x400G spine uplinks to achieve 1:1 (no) oversubscription

locals {
  backend_rack_leaf_count = 8
  backend_rack_leaf_definition = {
    logical_device_id = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count  = 2
    spine_link_speed  = "400G"
  }
}


resource "apstra_rack_type" "GPU-Backend" {
  name                       = "GPU Backend"
  description                = "AI Rail-optimized Rack Group of up to 16 H100-based or 32 A100-based Servers. 2 spine uplinks"
  fabric_connectivity_design = "l3clos"
  leaf_switches              = { for i in range(local.backend_rack_leaf_count) : "Leaf${i + 1}" => local.backend_rack_leaf_definition }
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
# It will result in some undersubscription when A100 is in use.
#
# The 4 DGX-H100 servers have 2 storage ports and we will home those
# to two separate leafs. The 8 HGX-A100 servers have only one storage port
# and we will connect 4 to each leaf

locals {
  storage_rack_leaf_count = 2
  storage_rack_leaf_definition = {
    logical_device_id = apstra_logical_device.AI-Leaf_16x400_32x200.id
    spine_link_count  = 4
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
      links = { for i in range(local.storage_rack_leaf_count) : "link${i + 1}" => {
        speed              = "400G"
        target_switch_name = "Leaf${i + 1}"
      } }
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
  storage_weka_rack_leaf_definition = local.backend_rack_leaf_definition
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

resource "apstra_template_rack_based" "AI_Cluster_GPUs" {
  name                     = "AI Cluster GPU Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_288x400.id
  }
  rack_infos = {
    (apstra_rack_type.GPU-Backend.id) = { count = 2 }
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
}