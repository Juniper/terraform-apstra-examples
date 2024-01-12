
locals {
  leaf_cidr_block_prefix_length  = 16
  leaf_net_desired_prefix_length = 24

  // Small Leaves start from 100.200.9.0/24 go to 100.200.16.0/24
  leaf_cidr_block_base_address_gpu_small_leafs   = "10.200.0.0"
  leaf_cidr_block_base_address_gpu_small_leafs_start_network   = 9

  // Medium leaves start from 100.200.1.0/24 go to 10.200.8.0/24
  leaf_cidr_block_base_address_gpu_med_leafs   = "10.200.0.0"
  leaf_cidr_block_base_address_gpu_med_leafs_start_network   = 1

  small_switch_to_ct = {
    for d in apstra_datacenter_device_allocation.gpu_small_leafs:
    d.node_id => apstra_datacenter_connectivity_template.gpu_small_leafs[index(apstra_datacenter_device_allocation.gpu_small_leafs, d)].id
  }
  med_switch_to_ct = {
    for d in apstra_datacenter_device_allocation.gpu_med_leafs:
    d.node_id => apstra_datacenter_connectivity_template.gpu_med_leafs[index(apstra_datacenter_device_allocation.gpu_med_leafs, d)].id
  }

  small_leaf_ifs = [
    for l in data.apstra_datacenter_interfaces_by_system.gpu_small_links_by_leafs:
    [for k,v in l.if_map : v if k!="et-0/0/0" && k!="et-0/0/1"&& k!="et-0/0/2"&& k!="et-0/0/3" && !startswith(v,"gpu_backend")]
  ]

  med_leaf_ifs = [
    for l in data.apstra_datacenter_interfaces_by_system.gpu_med_links_by_leafs:
    [for k,v in l.if_map : v if k!="et-0/0/0" && k!="et-0/0/1"&& k!="et-0/0/2"&& k!="et-0/0/3" && !startswith(v,"gpu_backend")]
  ]

}

resource "apstra_datacenter_virtual_network" "gpu_small_leafs" {
  count = length(apstra_datacenter_device_allocation.gpu_small_leafs)
  blueprint_id                 = apstra_datacenter_device_allocation.gpu_small_leafs[count.index].blueprint_id
  name                         = apstra_datacenter_device_allocation.gpu_small_leafs[count.index].node_name
  type                         = "vlan"
  ipv4_subnet                  = cidrsubnet("${local.leaf_cidr_block_base_address_gpu_small_leafs}/${local.leaf_cidr_block_prefix_length}", local.leaf_net_desired_prefix_length - local.leaf_cidr_block_prefix_length, local.leaf_cidr_block_base_address_gpu_small_leafs_start_network+count.index)
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = { (apstra_datacenter_device_allocation.gpu_small_leafs[count.index].node_id) = {} }
}

data "apstra_datacenter_ct_virtual_network_single" "gpu_small_leafs" {
  count = length(apstra_datacenter_device_allocation.gpu_small_leafs)
  vn_id    = apstra_datacenter_virtual_network.gpu_small_leafs[count.index].id
  name     = apstra_datacenter_virtual_network.gpu_small_leafs[count.index].name
}

resource "apstra_datacenter_connectivity_template" "gpu_small_leafs" {
  count = length(apstra_datacenter_virtual_network.gpu_small_leafs)
  blueprint_id                 = apstra_datacenter_virtual_network.gpu_small_leafs[count.index].blueprint_id
  name         = apstra_datacenter_virtual_network.gpu_small_leafs[count.index].name
  description  = apstra_datacenter_virtual_network.gpu_small_leafs[count.index].ipv4_subnet
  primitives = [
    data.apstra_datacenter_ct_virtual_network_single.gpu_small_leafs[count.index].primitive
  ]
}

resource "apstra_datacenter_virtual_network" "gpu_med_leafs" {
  count = length(apstra_datacenter_device_allocation.gpu_med_leafs)
  blueprint_id                 = apstra_datacenter_device_allocation.gpu_med_leafs[count.index].blueprint_id
  name                         = apstra_datacenter_device_allocation.gpu_med_leafs[count.index].node_name
  type                         = "vlan"
  ipv4_subnet                  = cidrsubnet("${local.leaf_cidr_block_base_address_gpu_med_leafs}/${local.leaf_cidr_block_prefix_length}", local.leaf_net_desired_prefix_length - local.leaf_cidr_block_prefix_length, local.leaf_cidr_block_base_address_gpu_med_leafs_start_network + count.index)
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = { (apstra_datacenter_device_allocation.gpu_med_leafs[count.index].node_id) = {} }
}

data "apstra_datacenter_ct_virtual_network_single" "gpu_med_leafs" {
  count = length(apstra_datacenter_device_allocation.gpu_med_leafs)
  //count = 8
  vn_id    = apstra_datacenter_virtual_network.gpu_med_leafs[count.index].id
  name     = apstra_datacenter_virtual_network.gpu_med_leafs[count.index].name
}

resource "apstra_datacenter_connectivity_template" "gpu_med_leafs" {
  count = length(apstra_datacenter_virtual_network.gpu_med_leafs)
  //count = 8
  blueprint_id  = apstra_datacenter_virtual_network.gpu_med_leafs[count.index].blueprint_id
  name         = apstra_datacenter_virtual_network.gpu_med_leafs[count.index].name
  description  = apstra_datacenter_virtual_network.gpu_med_leafs[count.index].ipv4_subnet
  primitives = [
    data.apstra_datacenter_ct_virtual_network_single.gpu_med_leafs[count.index].primitive
  ]
}

data "apstra_datacenter_interfaces_by_system" "gpu_small_links_by_leafs" {
  count = length(apstra_datacenter_virtual_network.gpu_small_leafs)
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  system_id = apstra_datacenter_device_allocation.gpu_small_leafs[count.index].node_id
}


data "apstra_datacenter_interfaces_by_system" "gpu_med_links_by_leafs" {
  count = length(apstra_datacenter_virtual_network.gpu_med_leafs)
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  system_id = apstra_datacenter_device_allocation.gpu_med_leafs[count.index].node_id
}

resource "apstra_datacenter_connectivity_template_assignments" "gpu_small_assign_ct" {
  count = local.count_small_leafs
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  application_point_ids = local.small_leaf_ifs[count.index]  #List of interfaces on the switch
  connectivity_template_id = apstra_datacenter_connectivity_template.gpu_small_leafs[count.index].id
}


resource "apstra_datacenter_connectivity_template_assignments" "gpu_med_assign_ct" {
  count = local.count_med_leafs
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  application_point_ids = local.med_leaf_ifs[count.index]  #List of interfaces on the switch
  connectivity_template_id = apstra_datacenter_connectivity_template.gpu_med_leafs[count.index].id
}