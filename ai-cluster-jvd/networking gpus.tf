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