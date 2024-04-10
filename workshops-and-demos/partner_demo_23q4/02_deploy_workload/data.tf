data "terraform_remote_state" "setup_fabric" {
  backend = "local"
  config = {
    path = "../01_setup_fabric/terraform.tfstate"
  }
}

locals {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
}

data "apstra_datacenter_systems" "leafs" {
  blueprint_id = local.blueprint_id
  filters = [{
    type = "switch"
    role = "leaf"
  }]
}

data "apstra_datacenter_virtual_network_binding_constructor" "example" {
  blueprint_id = local.blueprint_id
  switch_ids   = data.apstra_datacenter_systems.leafs.ids
}

data "apstra_datacenter_system" "leafs" {
  for_each     = data.apstra_datacenter_systems.leafs.ids
  blueprint_id = local.blueprint_id
  id           = each.key
}

locals {
  compute_leaf_name_prefixes = toset([for leaf in data.apstra_datacenter_system.leafs : one(regex("(.*)[12]", leaf.name)) if strcontains(leaf.name, "compute")])
  storage_leaf_name_prefixes = toset([for leaf in data.apstra_datacenter_system.leafs : one(regex("(.*)[12]", leaf.name)) if strcontains(leaf.name, "storage")])
}

data "apstra_datacenter_system" "compute_leafs" {
  for_each = toset(flatten([
    [for p in local.compute_leaf_name_prefixes : "${p}1"],
    [for p in local.compute_leaf_name_prefixes : "${p}2"],
  ]))
  blueprint_id = local.blueprint_id
  name         = each.key
}

locals {
  compute_leaf_names = sort([for k, v in data.apstra_datacenter_system.compute_leafs : k])
}

data "apstra_datacenter_system" "storage_leafs" {
  for_each = toset(flatten([
    [for p in local.storage_leaf_name_prefixes : "${p}1"],
    [for p in local.storage_leaf_name_prefixes : "${p}2"],
  ]))
  blueprint_id = local.blueprint_id
  name         = each.key
}

locals {
  storage_leaf_names = sort([for k, v in data.apstra_datacenter_system.storage_leafs : k])
}


#data "apstra_datacenter_system" "compute_leafs" {
#  for_each     = toset([for leaf in data.apstra_datacenter_system.leafs : leaf.id if strcontains(leaf.name, "compute") && true])
#  blueprint_id = local.blueprint_id
#  id           = each.key
#}
#
#locals {
#  compute_leafs = [for leaf in data.apstra_datacenter_system.leafs : leaf.id if strcontains(leaf.name, "compute")]
#}