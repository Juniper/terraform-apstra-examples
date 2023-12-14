
locals {
  leaf_cidr_block_prefix_length  = 16
  leaf_net_desired_prefix_length = 24

  // Small Leaves start from 100.200.9.0/24 go to 100.200.16.0/24
  leaf_cidr_block_base_address_gpu_small_leafs   = "10.200.0.0"
  leaf_cidr_block_base_address_gpu_small_leafs_start_network   = 9

  // Medium leaves start from 100.200.1.0/24 go to 10.200.8.0/24
  leaf_cidr_block_base_address_gpu_med_leafs   = "10.200.0.0"
  leaf_cidr_block_base_address_gpu_med_leafs_start_network   = 1

#  This is defined elsewhere (networking_mgmt.tf)
#  // Frontend leaf1 compute IP range 10.10.1.0/24
#  leaf_cidr_block_base_address_frontend_leaf1_compute   = "10.10.0.0"
#  leaf_cidr_block_base_address_frontend_leaf1_compute_start_network   = 1
#
#  // Frontend leaf2 storage IP range 10.10.2.0/24
#  leaf_cidr_block_base_address_frontend_leaf2_storage   = "10.10.0.0"
#  leaf_cidr_block_base_address_frontend_leaf2_storage_start_network   = 2
#
#  // Frontend leaf1 headend IP range 10.10.3.0/24
#  leaf_cidr_block_base_address_frontend_leaf1_headend   = "10.10.0.0"
#  leaf_cidr_block_base_address_frontend_leaf1_headend_start_network   = 3

  // Storage leafs1 compute IP range 10.100.1.0/24
  leaf_cidr_block_base_address_storage_leafs1_compute   = "10.100.0.0"
  leaf_cidr_block_base_address_storage_leafs1_compute_start_network   = 1

  // Storage leafs2 storage IP range 10.100.3.0/24
  leaf_cidr_block_base_address_storage_leafs2_storage   = "10.100.0.0"
  leaf_cidr_block_base_address_storage_leafs2_storage_start_network   = 3

}
resource "apstra_datacenter_virtual_network" "storage_leafs1_compute" {
  count = length(apstra_datacenter_device_allocation.storage_leafs1)
  blueprint_id                 = apstra_datacenter_device_allocation.storage_leafs1[count.index].blueprint_id
  name                         = apstra_datacenter_device_allocation.storage_leafs1[count.index].node_name
  type                         = "vlan"
  ipv4_subnet                  = cidrsubnet("${local.leaf_cidr_block_base_address_storage_leafs1_compute}/${local.leaf_cidr_block_prefix_length}", local.leaf_net_desired_prefix_length - local.leaf_cidr_block_prefix_length, local.leaf_cidr_block_base_address_storage_leafs1_compute_start_network + count.index)
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = { (apstra_datacenter_device_allocation.storage_leafs1[count.index].node_id) = {} }
}

data "apstra_datacenter_ct_virtual_network_single" "storage_leafs1_compute" {
  count = length(apstra_datacenter_device_allocation.storage_leafs1)
  vn_id    = apstra_datacenter_virtual_network.storage_leafs1_compute[count.index].id
  name     = apstra_datacenter_virtual_network.storage_leafs1_compute[count.index].name
}

resource "apstra_datacenter_connectivity_template" "storage_leafs1_compute" {
  count = length(apstra_datacenter_virtual_network.storage_leafs1_compute)
  blueprint_id                 = apstra_datacenter_virtual_network.storage_leafs1_compute[count.index].blueprint_id
  name         = apstra_datacenter_virtual_network.storage_leafs1_compute[count.index].name
  description  = apstra_datacenter_virtual_network.storage_leafs1_compute[count.index].ipv4_subnet
  primitives = [
    data.apstra_datacenter_ct_virtual_network_single.storage_leafs1_compute[count.index].primitive
  ]
}

resource "apstra_datacenter_virtual_network" "storage_leafs2_storage" {
  count = length(apstra_datacenter_device_allocation.storage_leafs2)
  blueprint_id                 = apstra_datacenter_device_allocation.storage_leafs2[count.index].blueprint_id
  name                         = apstra_datacenter_device_allocation.storage_leafs2[count.index].node_name
  type                         = "vlan"
  ipv4_subnet                  = cidrsubnet("${local.leaf_cidr_block_base_address_storage_leafs2_storage}/${local.leaf_cidr_block_prefix_length}", local.leaf_net_desired_prefix_length - local.leaf_cidr_block_prefix_length, local.leaf_cidr_block_base_address_storage_leafs2_storage_start_network + count.index)
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = { (apstra_datacenter_device_allocation.storage_leafs2[count.index].node_id) = {} }
}

data "apstra_datacenter_ct_virtual_network_single" "storage_leafs2_storage" {
  count = length(apstra_datacenter_device_allocation.storage_leafs2)
  vn_id    = apstra_datacenter_virtual_network.storage_leafs2_storage[count.index].id
  name     = apstra_datacenter_virtual_network.storage_leafs2_storage[count.index].name
}

resource "apstra_datacenter_connectivity_template" "storage_leafs2_storage" {
  count = length(apstra_datacenter_virtual_network.storage_leafs2_storage)
  blueprint_id                 = apstra_datacenter_virtual_network.storage_leafs2_storage[count.index].blueprint_id
  name         = apstra_datacenter_virtual_network.storage_leafs2_storage[count.index].name
  description  = apstra_datacenter_virtual_network.storage_leafs2_storage[count.index].ipv4_subnet
  primitives = [
    data.apstra_datacenter_ct_virtual_network_single.storage_leafs2_storage[count.index].primitive
  ]
}
