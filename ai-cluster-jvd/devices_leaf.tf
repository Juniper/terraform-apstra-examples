# LD for the Juniper QFX5220 (aka Small leaf)

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
