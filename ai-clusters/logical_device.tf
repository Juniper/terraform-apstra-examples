# This file will have the AI related logical devices

## AI related Leafs
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

## AI related spines
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