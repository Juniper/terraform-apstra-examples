resource "apstra_logical_device" "vJunos_LD" {
  name = "vJunos-LD"
  panels = [
    {
      rows = 1
      columns = 10
      port_groups = [
        {
          port_count = 10
          port_speed = "10G"
          port_roles = ["spine", "leaf", "peer", "access", "generic"]
        }
      ]
    }
  ]
}