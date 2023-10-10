
# use binding constructor and find out the node ID for the logical node in graph db

data "apstra_datacenter_virtual_network_binding_constructor" "frontend_leafs" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  switch_ids   = [
    apstra_datacenter_device_allocation.frontend-leafs1.node_id,
    apstra_datacenter_device_allocation.frontend_leafs2.node_id
  ]
}


# get ID of default routing zone

data "apstra_datacenter_routing_zone" "default_frontend_rz" {
  blueprint_id   = apstra_datacenter_blueprint.mgmt_bp.id
  name           = "default"
}

# create virtual networks in blueprint

resource "apstra_datacenter_virtual_network" "frontend_vn" {
  name                         = "frontent_VN"
  blueprint_id                 = apstra_datacenter_blueprint.mgmt_bp.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default_frontend_rz.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.1.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.frontend_leafs.bindings
}


# use VN ID to create data source for CT for frontend network

data "apstra_datacenter_ct_virtual_network_single" "frontend_vn" {
    vn_id = apstra_datacenter_virtual_network.frontend_vn.id
    tagged = false
}

# create IP Link data source for CT for backend L3 connections down to GPUs
# find ID of default routing zone for this

data "apstra_datacenter_routing_zone" "backend_default_rz" {
  blueprint_id = apstra_datacenter_blueprint.gpus_bp.id
  name           = "default"
}

data "apstra_datacenter_ct_ip_link" "backend_to_gpu" {
  routing_zone_id      = data.apstra_datacenter_routing_zone.backend_default_rz.id
  ipv4_addressing_type = "numbered"
  ipv6_addressing_type = "none"
}

# create IP Link data source for CT for storage L3 connections down to GPU Storage links and Weka Storage
# find ID of default routing zone for this

data "apstra_datacenter_routing_zone" "storage_default_rz" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  name           = "default"
}

data "apstra_datacenter_ct_ip_link" "l3_to_storage" {
  routing_zone_id      = data.apstra_datacenter_routing_zone.storage_default_rz.id
  ipv4_addressing_type = "numbered"
  ipv6_addressing_type = "none"
}

# create actual frontend CT for VNs now by attaching the primitive from the data source

resource "apstra_datacenter_connectivity_template" "frontend_ct" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  name         = "Frontend_VLAN"
  description  = "Frontend untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.frontend_vn.primitive
  ]
}

# create the L3 IP Link CT by attaching primitive from data source

resource "apstra_datacenter_connectivity_template" "backend_to_gpu_l3_ct" {
  blueprint_id = apstra_datacenter_blueprint.gpus_bp.id
  name         = "L3_to_GPUs"
  description  = "L3 link to GPUs for IP connectivity in IP Fabric"
  primitives   = [
    data.apstra_datacenter_ct_ip_link.backend_to_gpu.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "storage_l3_ct" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  name         = "L3_to_Storage"
  description  = "L3 link to Storage nodes for IP connectivity in IP Fabric"
  primitives   = [
    data.apstra_datacenter_ct_ip_link.l3_to_storage.primitive
  ]
}

# gather graph IDs for all interfaces based on their role = leaf

# data "apstra_datacenter_systems" "only_leafs" {
#   blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
#   filter = {
#     role = "leaf"
#   }
# }

data "apstra_datacenter_systems" "leafs" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  filters = [
    {
      role        = "leaf"
      system_type = "switch"
    },
  ]
}


data "apstra_datacenter_interfaces_by_system" "frontend" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  system_id = one(data.apstra_datacenter_systems.leafs.ids)
}

# data "apstra_datacenter_interfaces_by_link_tag" "qfx5220_a100_gpu" {
#     blueprint_id = apstra_datacenter_blueprint.backend_blueprint.id
#     tags         = ["qfx5220_a100_gpu"]
# }

# data "apstra_datacenter_interfaces_by_link_tag" "qfx5230_a100_gpu" {
#     blueprint_id = apstra_datacenter_blueprint.backend_blueprint.id
#     tags         = ["qfx5230_a100_gpu"]
# }

# data "apstra_datacenter_interfaces_by_link_tag" "qfx5220_h100_gpu" {
#     blueprint_id = apstra_datacenter_blueprint.backend_blueprint.id
#     tags         = ["qfx5220_h100_gpu"]
# }

# data "apstra_datacenter_interfaces_by_link_tag" "qfx5230_h100_gpu" {
#     blueprint_id = apstra_datacenter_blueprint.backend_blueprint.id
#     tags         = ["qfx5230_h100_gpu"]
# }

# assign CT to application points

# create count loop using the actual count of each generic system type
# and then loop through list using count.index when assigning application point

# count * 8 because each stripe has 8 leafs and there are two stripes, and each GPU connects to all 8 leafs

# resource "apstra_datacenter_connectivity_template_assignment" "backend_5220_assign_ct_a100" {
#   count = apstra_rack_type.backend_rack_qfx5220.generic_systems.A100_GPUs.count * 8
#   blueprint_id              = apstra_datacenter_blueprint.backend_blueprint.id
#   application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.qfx5220_a100_gpu.ids)[count.index]
#   connectivity_template_ids = [
#     apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
#     ]
# }

# resource "apstra_datacenter_connectivity_template_assignment" "backend_5230_assign_ct_a100" {
#   count = apstra_rack_type.backend_rack_qfx5230.generic_systems.A100_GPUs.count * 8
#   blueprint_id              = apstra_datacenter_blueprint.backend_blueprint.id
#   application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.qfx5230_a100_gpu.ids)[count.index]
#   connectivity_template_ids = [
#     apstra_datacenter_connectivity_template.backend_to_gpu_l3_ct.id
#     ]
# }

resource "apstra_datacenter_connectivity_template_assignment" "frontend_assign_ct" {
  count = apstra_rack_type.Frontend-Mgmt-AI.generic_systems.HGX-Mgmt.count
  blueprint_id              = apstra_datacenter_blueprint.mgmt_bp.id
  application_point_id      = data.apstra_datacenter_interfaces_by_system.frontend.ids[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.frontend_ct.id
    ]
}