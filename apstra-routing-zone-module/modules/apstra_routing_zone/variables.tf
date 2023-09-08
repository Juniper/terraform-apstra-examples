variable "name" {
  description = "Name of the routing zone"
}
variable "blueprint_id"{
  description= "ID of the blueprint"
}
variable "vlan_id" {
  description = "VLAN ID"
}
variable "dhcp_servers" {
  description= "List of DHCP server IPs"
  type= list(string)
}
variable "vni" {
  description = "VNI"
}
variable "role" {
  description = "Role for resource pool allocation"
}
variable "pool_ids" {
  description = "List of pool IDs"
  type= list(string)
}