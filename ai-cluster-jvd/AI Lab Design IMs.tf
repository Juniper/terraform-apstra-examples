#
# INTERFACE MAPS (IMs)
# for the design mapping the logical devices to physical device types
#

#
# IMS for leafs
#
# Small leaf is the 32x400 device QFX5220, Medium is the 64x400 QFX5230
#
# Actual setup shows example of mixed A100 and H100-based servers in the same stripe and leaf
# Server-facing ports are divided half and half at each speed of 200G and 400G respectively for
# A100 and H100 GPUs
#

locals {
  ai_leaf_small_200_spine_port_count    = apstra_logical_device.ai_lab_leaf_small.panels[0].port_groups[0].port_count // the 400G "spine" port group has a count of 16
  ai_leaf_small_200_spine_ld_port_first = 1                                                                           // first logical device "spine" port is 1/1
  ai_leaf_small_200_spine_dp_port_first = 0                                                                           // first physical device "spine" port is et-0/0/0

  ai_leaf_small_200_server_port_count    = apstra_logical_device.ai_lab_leaf_small.panels[0].port_groups[1].port_count            // the 200G "server" port group has a count of 16
  ai_leaf_small_200_server_ld_port_first = local.ai_leaf_small_200_spine_ld_port_first + local.ai_leaf_small_200_spine_port_count // first logical device "server" port is 1/17
  ai_leaf_small_200_server_dp_port_first = local.ai_leaf_small_200_spine_dp_port_first + local.ai_leaf_small_200_spine_port_count // first physical device "server" port is et-0/0/16

  ai_leaf_small_400_server_port_count    = apstra_logical_device.ai_lab_leaf_small.panels[0].port_groups[2].port_count                    // the 400G "server" port group has a count of 8
  ai_leaf_small_400_server_ld_port_first = local.ai_leaf_small_200_server_ld_port_first + local.ai_leaf_small_200_server_port_count       // first logical device "server" port is 1/33
  ai_leaf_small_400_server_dp_port_first = local.ai_leaf_small_200_server_dp_port_first + (local.ai_leaf_small_200_server_port_count / 2) // first physical device "server" port is et-0/0/24
}

resource "apstra_interface_map" "ai_lab_leaf_small" {
  name              = "${apstra_logical_device.ai_lab_leaf_small.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.ai_lab_leaf_small.id
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
        logical_device_port     = "1/${local.ai_leaf_small_400_server_ld_port_first + i}"      // 1/17 through 1/48
        physical_interface_name = "et-0/0/${local.ai_leaf_small_400_server_dp_port_first + i}" // et-0/0/24 through et-0/0/31
      }
    ],
  ])
}


locals {
  ai_leaf_medium_200_spine_port_count    = apstra_logical_device.ai_lab_leaf_medium.panels[0].port_groups[0].port_count // the 400G "spine" port group has a count of 32
  ai_leaf_medium_200_spine_ld_port_first = 1                                                                            // first logical device "spine" port is 1/1
  ai_leaf_medium_200_spine_dp_port_first = 0                                                                            // first physical device "spine" port is et-0/0/0

  ai_leaf_medium_200_server_port_count    = apstra_logical_device.ai_lab_leaf_medium.panels[0].port_groups[1].port_count             // the 200G "server" port group has a count of 32
  ai_leaf_medium_200_server_ld_port_first = local.ai_leaf_medium_200_spine_ld_port_first + local.ai_leaf_medium_200_spine_port_count // first logical device "server" port is 1/33
  ai_leaf_medium_200_server_dp_port_first = local.ai_leaf_medium_200_spine_dp_port_first + local.ai_leaf_medium_200_spine_port_count // first physical device "server" port is et-0/0/32

  ai_leaf_medium_400_server_port_count    = apstra_logical_device.ai_lab_leaf_medium.panels[0].port_groups[2].port_count                     // the 400G "server" port group has a count of 16
  ai_leaf_medium_400_server_ld_port_first = local.ai_leaf_medium_200_server_ld_port_first + local.ai_leaf_medium_200_server_port_count       // first logical device "server" port is 1/64
  ai_leaf_medium_400_server_dp_port_first = local.ai_leaf_medium_200_server_dp_port_first + (local.ai_leaf_medium_200_server_port_count / 2) // first physical device "server" port is et-0/0/48
}

resource "apstra_interface_map" "ai_lab_leaf_medium" {
  name              = "${apstra_logical_device.ai_lab_leaf_medium.name}__QFX5230-64CD"
  logical_device_id = apstra_logical_device.ai_lab_leaf_medium.id
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
        logical_device_port     = "1/${local.ai_leaf_medium_400_server_ld_port_first + i}"      // 1/64 through 1/80
        physical_interface_name = "et-0/0/${local.ai_leaf_medium_400_server_dp_port_first + i}" // et-0/0/48 through et-0/0/63
      }
    ],
  ])
}

#
# Leafs with uniform 200G access such as the Weka server racks
#

locals {
  ai_leaf_16x400_32x200_spine_port_count    = apstra_logical_device.ai_leaf_small_200.panels[0].port_groups[0].port_count // the "spine" port group has a count of 16
  ai_leaf_16x400_32x200_spine_ld_port_first = 1                                                                           // first logical device "spine" port is 1/1
  ai_leaf_16x400_32x200_spine_dp_port_first = 0                                                                           // first physical device "spine" port is et-0/0/0

  ai_leaf_16x400_32x200_server_port_count    = apstra_logical_device.ai_leaf_small_200.panels[0].port_groups[1].port_count                    // the "server" port group has a count of 32
  ai_leaf_16x400_32x200_server_ld_port_first = local.ai_leaf_16x400_32x200_spine_ld_port_first + local.ai_leaf_16x400_32x200_spine_port_count // first logical device "server" port is 1/17
  ai_leaf_16x400_32x200_server_dp_port_first = local.ai_leaf_16x400_32x200_spine_dp_port_first + local.ai_leaf_16x400_32x200_spine_port_count // first physical device "server" port is et-0/0/16
}

resource "apstra_interface_map" "ai_leaf_16x400_32x200" {
  name              = "${apstra_logical_device.ai_leaf_small_200.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.ai_leaf_small_200.id
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

#
#  Leafs with uniform 100G access such as frontend racks
#

locals {
  ai_leaf_16x400_64x100_spine_port_count    = apstra_logical_device.ai_leaf_16x400_64x100.panels[0].port_groups[0].port_count // the "spine" port group has a count of 16
  ai_leaf_16x400_64x100_spine_ld_port_first = 1                                                                               // first logical device "spine" port is 1/1
  ai_leaf_16x400_64x100_spine_dp_port_first = 0                                                                               // first physical device "spine" port is et-0/0/0

  ai_leaf_16x400_64x100_server_port_count    = apstra_logical_device.ai_leaf_16x400_64x100.panels[0].port_groups[1].port_count                // the "server" port group has a count of 64
  ai_leaf_16x400_64x100_server_ld_port_first = local.ai_leaf_16x400_64x100_spine_ld_port_first + local.ai_leaf_16x400_64x100_spine_port_count // first logical device "server" port is 1/17
  ai_leaf_16x400_64x100_server_dp_port_first = local.ai_leaf_16x400_64x100_spine_dp_port_first + local.ai_leaf_16x400_64x100_spine_port_count // first physical device "server" port is et-0/0/16
}

resource "apstra_interface_map" "ai_leaf_16x400_64x100" {
  name              = "${apstra_logical_device.ai_leaf_16x400_64x100.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.ai_leaf_16x400_64x100.id
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

#
# IMs for spines of 32x400 and 64x400 respectively
#

locals {
  ai_spine_32x400_port_count    = apstra_logical_device.ai_spine_32x400.panels[0].port_groups[0].port_count // the port group has a count of 32
  ai_spine_32x400_ld_port_first = 1                                                                         // first logical device "spine" port is 1/1
  ai_spine_32x400_dp_port_first = 0                                                                         // first physical device "spine" port is et-0/0/0
}

resource "apstra_interface_map" "ai_spine_32x400" {
  name              = "${apstra_logical_device.ai_spine_32x400.name}__QFX5220-32CD"
  logical_device_id = apstra_logical_device.ai_spine_32x400.id
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
  ai_spine_64x400_port_count    = apstra_logical_device.ai_spine_64x400.panels[0].port_groups[0].port_count // the port group has a count of 64
  ai_spine_64x400_ld_port_first = 1                                                                         // first logical device "spine" port is 1/1
  ai_spine_64x400_dp_port_first = 0                                                                         // first physical device "spine" port is et-0/0/0
}

resource "apstra_interface_map" "ai_spine_64x400" {
  name              = "${apstra_logical_device.ai_spine_64x400.name}__QFX5230-64CD"
  logical_device_id = apstra_logical_device.ai_spine_64x400.id
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

# IM for the PTX spine


locals {
  ptx10008_backend_if_map = [
    { # map logical 1/1 - 1/32 to physical et-0/0/0 - et-0/0/31
      # this is for 36x400G on slot 0 of PTX10008
      ld_panel       = 1
      ld_first_port  = 1
      phy_prefix     = "et-0/0/"
      phy_first_port = 0
      count          = 36
    },
    { # map logical 2/1 - 2/32 to physical et-1/0/0 - et-1/0/31
      # this is for 36x400G on slot 1 of PTX 10008
      ld_panel       = 2
      ld_first_port  = 1
      phy_prefix     = "et-1/0/"
      phy_first_port = 0
      count          = 36
    },
  ]
  ptx10008_backend_interfaces = [
    for map in local.ptx10008_backend_if_map : [
      for i in range(map.count) : {
        logical_device_port     = format("%d/%d", map.ld_panel, map.ld_first_port + i)
        physical_interface_name = format("%s%d", map.phy_prefix, map.phy_first_port + i)
      }
    ]
  ]
}

resource "apstra_modular_device_profile" "ptx10008_72x400" {
  name               = "Juniper_PTX10008_72x400"
  chassis_profile_id = "Juniper_PTX10008"
  line_card_profile_ids = {
    0 = "Juniper_PTX10K_LC1201_36CD"
    1 = "Juniper_PTX10K_LC1201_36CD"
  }
}

resource "apstra_interface_map" "ai_spine_ptx10008_72x400" {
  name              = "${apstra_logical_device.ai_spine_72x400.name}___PTX10008-2LC-72x400"
  logical_device_id = apstra_logical_device.ai_spine_72x400.id
  device_profile_id = apstra_modular_device_profile.ptx10008_72x400.id
  interfaces        = flatten([local.ptx10008_backend_interfaces])
}