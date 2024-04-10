resource "apstra_logical_device" "storage_leaf" {
  name = "storage_leaf"
  panels = [
    {
      rows = 2
      columns = 16
      port_groups = [
        {
          port_count = 32
          port_speed = "100G"
        }
      ]
    }
  ]
}