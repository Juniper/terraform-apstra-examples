#
# Setup the backend GPU fabric networking with L3 routing only
#

# Get ID of default routing zone for this blueprint

data "apstra_datacenter_routing_zone" "backend_default_rz" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  name         = "default"
}

# Create IP Link data source for CT for backend L3 connections down to GPUs

data "apstra_datacenter_ct_ip_link" "backend_to_gpu" {
  routing_zone_id      = data.apstra_datacenter_routing_zone.backend_default_rz.id
  ipv4_addressing_type = "numbered"
  ipv6_addressing_type = "none"
}

# Create the L3 IP Link CT by attaching primitive from data source

resource "apstra_datacenter_connectivity_template" "backend_to_gpu_l3_ct" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  name         = "L3_to_GPUs"
  description  = "L3 link to GPUs for IP connectivity in IP Fabric"
  primitives = [
    data.apstra_datacenter_ct_ip_link.backend_to_gpu.primitive
  ]
}


#
# Assign the backend gpu fabric CTs
#
# count * 8 because each stripe has 8 leafs and there are two stripes, and each GPU connects to all 8 leafs

#
# A100 HGX servers:
#
data "apstra_datacenter_interfaces_by_link_tag" "gpu_small_a100_links" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  tags         = ["gpu_a100", "gpu_small"]
}

resource "apstra_datacenter_connectivity_template_assignment" "gpu_small_assign_ct_a100" {
  count                = apstra_rack_type.gpu_backend_sml.generic_systems.hgx_a100.count * local.backend_rack_leaf_count
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_small_a100_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "gpu_medium_a100_links" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  tags         = ["gpu_a100", "gpu_medium"]
}

resource "apstra_datacenter_connectivity_template_assignment" "gpu_medium_assign_ct_a100" {
  count                = apstra_rack_type.gpu_backend_med.generic_systems.hgx_a100.count * local.backend_rack_leaf_count
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_medium_a100_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
  ]
}

#
# H100 DGX Servers:
#

data "apstra_datacenter_interfaces_by_link_tag" "gpu_small_h100_links" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  tags         = ["gpu_h100", "gpu_small"]
}

resource "apstra_datacenter_connectivity_template_assignment" "gpu_small_assign_ct_h100" {
  count                = apstra_rack_type.gpu_backend_sml.generic_systems.dgx_h100.count * local.backend_rack_leaf_count
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_small_h100_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "gpu_medium_h100_links" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  tags         = ["gpu_h100", "gpu_medium"]
}

resource "apstra_datacenter_connectivity_template_assignment" "gpu_medium_assign_ct_h100" {
  count                = apstra_rack_type.gpu_backend_med.generic_systems.dgx_h100.count * local.backend_rack_leaf_count
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_medium_h100_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
  ]
}


resource "apstra_ipv4_pool" "gpus_subnet" {
  name = "GPUs subnet pool"
  subnets = [
    { network = "10.200.0.0/16" },
  ]
}

resource "apstra_datacenter_resource_pool_allocation" "gpu_subnet_alloc" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  pool_ids     = [apstra_ipv4_pool.gpus_subnet.id]
  role         = "to_generic_link_ips"
}


locals {
  leaf_cidr_block_base_address_gpu_leafs1   = "10.1.0.0"
  leaf_cidr_block_base_address_gpu_leafs2   = "10.2.0.0"
  leaf_cidr_block_prefix_length  = 16
  leaf_net_desired_prefix_length = 24
}

resource "apstra_datacenter_virtual_network" "gpu_leafs1" {
  count = length(apstra_datacenter_device_allocation.gpu_leafs1)
  blueprint_id                 = apstra_datacenter_device_allocation.gpu_leafs1[count.index].blueprint_id
  name                         = apstra_datacenter_device_allocation.gpu_leafs1[count.index].node_name
  type                         = "vlan"
  ipv4_subnet                  = cidrsubnet("${local.leaf_cidr_block_base_address_gpu_leafs1}/${local.leaf_cidr_block_prefix_length}", local.leaf_net_desired_prefix_length - local.leaf_cidr_block_prefix_length, count.index)
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = { (apstra_datacenter_device_allocation.gpu_leafs1[count.index].node_id) = {} }
}

data "apstra_datacenter_ct_virtual_network_single" "gpu_leafs1" {
  count = length(apstra_datacenter_device_allocation.gpu_leafs1)
  vn_id    = apstra_datacenter_virtual_network.gpu_leafs1[count.index].id
  name     = apstra_datacenter_virtual_network.gpu_leafs1[count.index].name
}

resource "apstra_datacenter_connectivity_template" "gpu_leafs1" {
  count = length(apstra_datacenter_virtual_network.gpu_leafs1)
  blueprint_id                 = apstra_datacenter_virtual_network.gpu_leafs1[count.index].blueprint_id
  name         = apstra_datacenter_virtual_network.gpu_leafs1[count.index].name
  description  = apstra_datacenter_virtual_network.gpu_leafs1[count.index].ipv4_subnet
  primitives = [
    data.apstra_datacenter_ct_virtual_network_single.gpu_leafs1[count.index].primitive
  ]
}

resource "apstra_datacenter_virtual_network" "gpu_leafs2" {
  count = length(apstra_datacenter_device_allocation.gpu_leafs2)
  blueprint_id                 = apstra_datacenter_device_allocation.gpu_leafs2[count.index].blueprint_id
  name                         = apstra_datacenter_device_allocation.gpu_leafs2[count.index].node_name
  type                         = "vlan"
  ipv4_subnet                  = cidrsubnet("${local.leaf_cidr_block_base_address_gpu_leafs2}/${local.leaf_cidr_block_prefix_length}", local.leaf_net_desired_prefix_length - local.leaf_cidr_block_prefix_length, count.index)
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = { (apstra_datacenter_device_allocation.gpu_leafs2[count.index].node_id) = {} }
}

data "apstra_datacenter_ct_virtual_network_single" "gpu_leafs2" {
  count = length(apstra_datacenter_device_allocation.gpu_leafs2)
  vn_id    = apstra_datacenter_virtual_network.gpu_leafs2[count.index].id
  name     = apstra_datacenter_virtual_network.gpu_leafs2[count.index].name
}

resource "apstra_datacenter_connectivity_template" "gpu_leafs2" {
  count = length(apstra_datacenter_virtual_network.gpu_leafs2)
  blueprint_id                 = apstra_datacenter_virtual_network.gpu_leafs2[count.index].blueprint_id
  name         = apstra_datacenter_virtual_network.gpu_leafs2[count.index].name
  description  = apstra_datacenter_virtual_network.gpu_leafs2[count.index].ipv4_subnet
  primitives = [
    data.apstra_datacenter_ct_virtual_network_single.gpu_leafs2[count.index].primitive
  ]
}

