locals {
  vJunos_if_map = [
    { # map logical 1/1 - 1/10 to physical ge-0/0/0 to ge-0/0/9     
      # this is a vJunos-switch device
      ld_panel       = 1
      ld_first_port  = 1
      phy_prefix     = "ge-0/0/"
      phy_first_port = 0
      count          = 10
    }
  ]
  vJunos_interfaces = [
    for map in local.vJunos_if_map : [
      for i in range(map.count) : {
        logical_device_port     = format("%d/%d", map.ld_panel, map.ld_first_port + i)
        physical_interface_name = format("%s%d", map.phy_prefix, map.phy_first_port + i)
      }
    ]
  ]
}

# create interface map for vJunos-switch with 10 data-plane ports

resource "apstra_interface_map" "vJunos_IM" {
  name              = "vJunos-IM"
  logical_device_id = apstra_logical_device.vJunos_LD.id
  device_profile_id = "164941fb-6e05-4b0e-81e2-8ffab8feb4d6"
  interfaces = flatten([local.vJunos_interfaces])
}