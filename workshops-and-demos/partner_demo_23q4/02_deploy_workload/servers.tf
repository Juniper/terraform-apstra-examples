resource "apstra_datacenter_generic_system" "hypervisor" {
  count        = local.hypervisor_node_count
  blueprint_id = local.blueprint_id
  name         = "hypervisor ${count.index + 1}"
  tags         = ["hypervisor"]
  links = [
    {
      tags                          = ["hypervisor", "hypervisor ${count.index + 1}"]
      target_switch_id              = data.apstra_datacenter_system.compute_leafs[local.compute_leaf_names[(count.index * 2) % length(local.compute_leaf_names)]].id
      target_switch_if_name         = "et-0/0/${floor(count.index / length(local.compute_leaf_name_prefixes))}"
      target_switch_if_transform_id = 1
      lag_mode                      = "lacp_active"
      group_label                   = "a"
    },
    {
      tags                          = ["hypervisor", "hypervisor ${count.index + 1}"]
      target_switch_id              = data.apstra_datacenter_system.compute_leafs[local.compute_leaf_names[(count.index * 2) % length(local.compute_leaf_names) + 1]].id
      target_switch_if_name         = "et-0/0/${floor(count.index / length(local.compute_leaf_name_prefixes))}"
      target_switch_if_transform_id = 1
      lag_mode                      = "lacp_active"
      group_label                   = "a"
    },
  ]
}

resource "apstra_datacenter_generic_system" "kubernetes" {
  count        = local.kubernetes_node_count
  blueprint_id = local.blueprint_id
  name         = "kubernetes ${count.index + 1}"
  tags         = ["kubernetes"]
  links = [
    {
      tags                          = ["kubernetes", "kubernetes ${count.index + 1}"]
      target_switch_id              = data.apstra_datacenter_system.compute_leafs[local.compute_leaf_names[(count.index * 2) % length(local.compute_leaf_names)]].id
      target_switch_if_name         = "et-0/0/${31 - floor(count.index / length(local.compute_leaf_name_prefixes))}"
      target_switch_if_transform_id = 1
      lag_mode                      = "lacp_active"
      group_label                   = "a"
    },
    {
      tags                          = ["kubernetes", "kubernetes ${count.index + 1}"]
      target_switch_id              = data.apstra_datacenter_system.compute_leafs[local.compute_leaf_names[(count.index * 2) % length(local.compute_leaf_names) + 1]].id
      target_switch_if_name         = "et-0/0/${31 - floor(count.index / length(local.compute_leaf_name_prefixes))}"
      target_switch_if_transform_id = 1
      lag_mode                      = "lacp_active"
      group_label                   = "a"
    },
  ]
}

resource "apstra_datacenter_generic_system" "storage" {
  count        = local.storage_node_count
  blueprint_id = local.blueprint_id
  name         = "storage ${count.index + 1}"
  tags         = ["storage"]
  links = [
    {
      tags                          = ["storage", "storage ${count.index + 1}"]
      target_switch_id              = data.apstra_datacenter_system.storage_leafs[local.storage_leaf_names[(count.index * 2) % length(local.storage_leaf_names)]].id
      target_switch_if_name         = "et-0/0/${16 + floor(count.index / length(local.storage_leaf_name_prefixes))}"
      target_switch_if_transform_id = 1
      lag_mode                      = "lacp_active"
      group_label                   = "a"
    },
    {
      tags                          = ["storage", "storage ${count.index + 1}"]
      target_switch_id              = data.apstra_datacenter_system.storage_leafs[local.storage_leaf_names[(count.index * 2) % length(local.storage_leaf_names) + 1]].id
      target_switch_if_name         = "et-0/0/${16 + floor(count.index / length(local.storage_leaf_name_prefixes))}"
      target_switch_if_transform_id = 1
      lag_mode                      = "lacp_active"
      group_label                   = "a"
    },
  ]
}
