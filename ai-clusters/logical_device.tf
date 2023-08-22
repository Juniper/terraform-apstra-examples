# This file will have the AI related logical devices

# AI related Leafs

# Examples of the Juniper QFX5220-32C where we would have 16 access ports and 16 fabric ports
resource "apstra_logical_device" "AI-Leaf_16_16x400" {
  name = "AI-Leaf 16+16x400"
  panels = [
    {
      rows = 2
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


# Examples of the QFX5220-32C where we would have 16 access ports
# and only 16 fabric ports. Access is native 200GE instead of the usual 400GE
resource "apstra_logical_device" "AI-Leaf_16x400_16x200" {
  name = "AI-Leaf 16x400+16x200"
  panels = [
    {
      rows = 2
      columns = 16
      port_groups = [
        {
          port_count = 16
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
        {
          port_count = 16
          port_speed = "200G"
          port_roles = ["superspine", "spine", "leaf", "peer", "access", "generic", "unused"]
        },
      ]
    }
  ]
}

# Examples of the QFX5220-32C where we would have 32 access ports and only
# 16 fabric ports. The access ports are for example 2x200GE breakout to 400GE
resource "apstra_logical_device" "AI-Leaf_16x400_32x200" {
  name = "AI-Leaf 16x400+32x200"
  panels = [
    {
      rows = 2
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

# Example of the Juniper QFX5230-64C with 32 access and 32 fabric 400GE ports
resource "apstra_logical_device" "AI-Leaf_32_32x400" {
  name = "AI-Leaf 32+32x400"
  panels = [
    {
      rows = 2
      columns = 32
      port_groups = [
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "generic"]
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

# AI related spine examples

# Example of the Juniper QFX5220-32C
resource "apstra_logical_device" "AI-Spine_32x400" {
  name = "AI-Spine 32x400"
  panels = [
    {
      rows = 2
      columns = 16
      port_groups = [
        {
          port_count = 32
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "generic"]
        },
      ]
    }
  ]
}

# Example of the Juniper QFX5230-64C
resource "apstra_logical_device" "AI-Spine_64x400" {
  name = "AI-Spine 64x400"
  panels = [
    {
      rows = 2
      columns = 32
      port_groups = [
        {
          port_count = 64
          port_speed = "400G"
          port_roles = ["superspine", "spine", "leaf", "unused", "generic"]
        },
      ]
    }
  ]
}

# Example of the Juniper PTX10000 line card of 36x400GE
locals {
  panel_2x18x400 = {
    rows = 2
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

# Examples LD for the Juniper PTX10008 and 10016 chassis devices
# For simplicity they are fully loaded with the 36x400GE line cards
resource "apstra_logical_device" "AI-Spine_288x400" {
  name   = "AI-Spine 288x400"
  panels = [
    local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400,
    local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400,
  ]
}

resource "apstra_logical_device" "AI-Spine_576x400" {
  name   = "AI-Spine 576x400"
  panels = [ local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400,
    local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400,
    local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400,
    local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400, local.panel_2x18x400,
    ]
}

# Examples of popular NVIDIA DGX or HGX equivalent servers
# A100s are 200GE connected and H100s are 400GE
# Both options have 8 GPUs each with a GPUDirect RDMA interface
resource "apstra_logical_device" "AI-Server-A100_8x200G" {
  name = "AI-A100-Server 8x200G"
  panels = [
    {
    rows = 2
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


resource "apstra_logical_device" "AI-Server-H100_8x400G" {
  name = "AI-H100-Server 8x400G"
  panels = [
    {
      rows = 2
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

# Examples of storage connectivity on the DGX or equivalents HGX servers
# They have 1 or 2 ports of 200G or 400G interfaces depending on server configuration
resource "apstra_logical_device" "AI-Storage_2x200G" {
  name = "AI-Storage 2x200G"
  panels = [
    {
    rows = 1
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


resource "apstra_logical_device" "AI-Storage_2x400G" {
  name = "AI-Storage 2x400G"
  panels = [
    {
      rows = 1
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

resource "apstra_logical_device" "AI-Storage_1x200G" {
  name = "AI-Storage 1x200G"
  panels = [
    {
    rows = 1
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


resource "apstra_logical_device" "AI-Storage_1x400G" {
  name = "AI-Storage 1x400G"
  panels = [
    {
      rows = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "400G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

# Example of a popular Lambda Labs option with Weka storage on a servers with 2x200G
resource "apstra_logical_device" "AI-Storage-Weka_2x200G" {
  name = "AI-Weka-Storage 2x200G"
  panels = [
    {
      rows = 1
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

# Logical device for AI cluster management/frontend network connectivity
# that is 100GE for all AI compute and storage servers
resource "apstra_logical_device" "AI-Mgmt_1x100G" {
  name = "AI-Mgmt 1x100G"
  panels = [
    {
    rows = 1
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
