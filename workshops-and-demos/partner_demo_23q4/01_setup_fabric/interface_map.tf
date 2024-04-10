resource "apstra_interface_map" "storage_leaf" {
  name              = "aaa storage leaf"
  logical_device_id = apstra_logical_device.storage_leaf.id
  device_profile_id = "Juniper_QFX5120-32C_Junos"
  interfaces = [for i in range(32) : {
    logical_device_port     = "1/${i + 1}"
    physical_interface_name = "et-0/0/${i}"
  }]
}