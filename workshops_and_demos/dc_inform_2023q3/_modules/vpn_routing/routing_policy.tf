resource "apstra_datacenter_routing_policy" "vpn" {
  for_each      = var.vpn_routing_policies
  blueprint_id  = var.blueprint_id
  name          = each.key
  description   = "${each.key}: Import count: ${length(each.value["import"])} Export count: ${length(each.value["export"])}"
  import_policy = "extra_only"
  extra_imports = [for i in each.value["import"] : { prefix = i, action = "permit" }]
  extra_exports = [for i in each.value["export"] : { prefix = i, action = "permit" }]
}
