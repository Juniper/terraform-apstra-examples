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
