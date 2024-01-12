#
# Setup the backend GPU fabric networking with L3 routing only
#

# Get ID of default routing zone for this blueprint
#
#data "apstra_datacenter_routing_zone" "backend_default_rz" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  name         = "default"
#}
#
## Create IP Link data source for CT for backend L3 connections down to GPUs
#
#data "apstra_datacenter_ct_ip_link" "backend_to_gpu" {
#  routing_zone_id      = data.apstra_datacenter_routing_zone.backend_default_rz.id
#  ipv4_addressing_type = "numbered"
#  ipv6_addressing_type = "none"
#}
#
## Create the L3 IP Link CT by attaching primitive from data source
#
#resource "apstra_datacenter_connectivity_template" "backend_to_gpu_l3_ct" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  name         = "L3_to_GPUs"
#  description  = "L3 link to GPUs for IP connectivity in IP Fabric"
#  primitives = [
#    data.apstra_datacenter_ct_ip_link.backend_to_gpu.primitive
#  ]
#}



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


locals {
#  small_system_to_if_ids = {
#    for l in data.apstra_datacenter_interfaces_by_system.gpu_small_links_by_leafs:
#      l.system_id=>[for k,v in l.if_map : v if k!="et-0/0/0" && k!="et-0/0/1"&& k!="et-0/0/2"&& k!="et-0/0/3"]
#  }
#
#  small_if_to_system_ids = transpose(local.small_system_to_if_ids)
#  small_if_to_system_id = {
#    for k, v in local.small_if_to_system_ids: k=> one(v) if !startswith(k, "gpu_backend")
#  }
  small_switch_to_ct = {
    for d in apstra_datacenter_device_allocation.gpu_small_leafs:
        d.node_id => apstra_datacenter_connectivity_template.gpu_small_leafs[index(apstra_datacenter_device_allocation.gpu_small_leafs, d)].id
  }
#
#  med_system_to_if_ids = {
#    for l in data.apstra_datacenter_interfaces_by_system.gpu_med_links_by_leafs:
#    l.system_id=>[for k,v in l.if_map : v if k!="et-0/0/0" && k!="et-0/0/1"&& k!="et-0/0/2"&& k!="et-0/0/3"]
#  }
#  med_if_to_system_ids = transpose(local.med_system_to_if_ids)
#  med_if_to_system_id = {
#    for k, v in local.med_if_to_system_ids: k=> one(v) if !startswith(k, "gpu_backend")
#  }
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
#
#resource "apstra_datacenter_connectivity_template_assignment" "gpu_med_assign_ct" {
#  for_each = local.med_if_to_system_id
#  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
#  application_point_id = each.key
#  connectivity_template_ids = [
#    local.med_switch_to_ct[each.value]
#  ]
#}
#
# Assign the backend gpu fabric CTs
#
# count * 8 because each stripe has 8 leafs and there are two stripes, and each GPU connects to all 8 leafs

#
# A100 HGX servers:
#
#data "apstra_datacenter_interfaces_by_link_tag" "gpu_small_a100_links" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  tags         = ["gpu_a100", "gpu_small"]
#}
#
#resource "apstra_datacenter_connectivity_template_assignment" "gpu_small_assign_ct_a100" {
#  count                = apstra_rack_type.gpu_backend_sml.generic_systems.hgx_a100.count * local.backend_rack_leaf_count
#  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
#  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_small_a100_links.ids)[count.index]
#  connectivity_template_ids = [
#    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
#  ]
#}
#
#data "apstra_datacenter_interfaces_by_link_tag" "gpu_medium_a100_links" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  tags         = ["gpu_a100", "gpu_medium"]
#}
#
#resource "apstra_datacenter_connectivity_template_assignment" "gpu_medium_assign_ct_a100" {
#  count                = apstra_rack_type.gpu_backend_med.generic_systems.hgx_a100.count * local.backend_rack_leaf_count
#  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
#  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_medium_a100_links.ids)[count.index]
#  connectivity_template_ids = [
#    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
#  ]
#}
#
##
## H100 DGX Servers:
##
#
#data "apstra_datacenter_interfaces_by_link_tag" "gpu_small_h100_links" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  tags         = ["gpu_h100", "gpu_small"]
#}
#
#resource "apstra_datacenter_connectivity_template_assignment" "gpu_small_assign_ct_h100" {
#  count                = apstra_rack_type.gpu_backend_sml.generic_systems.dgx_h100.count * local.backend_rack_leaf_count
#  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
#  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_small_h100_links.ids)[count.index]
#  connectivity_template_ids = [
#    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
#  ]
#}
#
#data "apstra_datacenter_interfaces_by_link_tag" "gpu_medium_h100_links" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  tags         = ["gpu_h100", "gpu_medium"]
#}
#
#resource "apstra_datacenter_connectivity_template_assignment" "gpu_medium_assign_ct_h100" {
#  count                = apstra_rack_type.gpu_backend_med.generic_systems.dgx_h100.count * local.backend_rack_leaf_count
#  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
#  application_point_id = tolist(data.apstra_datacenter_interfaces_by_link_tag.gpu_medium_h100_links.ids)[count.index]
#  connectivity_template_ids = [
#    apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
#  ]
#}
#
#
#resource "apstra_ipv4_pool" "gpus_subnet" {
#  name = "GPUs subnet pool"
#  subnets = [
#    { network = "10.200.0.0/16" },
#  ]
#}
#
#resource "apstra_datacenter_resource_pool_allocation" "gpu_subnet_alloc" {
#  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
#  pool_ids     = [apstra_ipv4_pool.gpus_subnet.id]
#  role         = "to_generic_link_ips"
#}

