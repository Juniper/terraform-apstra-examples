variable "blueprint_id" {
  type = string
}

variable "vpn_edge_router_ip" {
  type = string
}

variable "routing_zone_id" {
  type = string
}

variable "vpn_routing_policies" {
  type = map(
    object({
      import = list(string)
      export = list(string)
    })
  )
}
