#
# Setup the frontend mgmt fabric networking with a single VLAN / virtual network
#

# Get ID of default routing zone

data "apstra_datacenter_routing_zone" "default_frontend_rz" {
  blueprint_id   = apstra_datacenter_blueprint.mgmt_bp.id
  name           = "default"
}

# Use binding constructor and find out the node ID for the logical node in graph db

data "apstra_datacenter_virtual_network_binding_constructor" "leaf1" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  switch_ids   = [
    apstra_datacenter_device_allocation.frontend_leafs1.node_id
  ]
}

data "apstra_datacenter_virtual_network_binding_constructor" "leaf2" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  switch_ids   = [
    apstra_datacenter_device_allocation.frontend_leafs2.node_id
  ]
}



# Create virtual network compute in blueprint

resource "apstra_datacenter_virtual_network" "frontend_vn_compute" {
  name                         = "frontend_VN_compute"
  blueprint_id                 = apstra_datacenter_blueprint.mgmt_bp.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default_frontend_rz.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.1.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.leaf1.bindings
}

# use VN ID to create data source for CT for frontend network

data "apstra_datacenter_ct_virtual_network_single" "frontend_vn_compute" {
    vn_id = apstra_datacenter_virtual_network.frontend_vn_compute.id
    tagged = false
}

# create actual frontend CT for VNs now by attaching the primitive from the data source

resource "apstra_datacenter_connectivity_template" "frontend_ct1" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  name         = "Frontend_Compute_VLAN"
  description  = "Frontend compute untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.frontend_vn_compute.primitive
  ]
}

# Create virtual network storage in blueprint

resource "apstra_datacenter_virtual_network" "frontend_vn_storage" {
  name                         = "frontend_VN_storage"
  blueprint_id                 = apstra_datacenter_blueprint.mgmt_bp.id
  type                         = "vlan"
  routing_zone_id              = data.apstra_datacenter_routing_zone.default_frontend_rz.id
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = false
  ipv4_subnet                  = "10.10.2.0/24"
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.leaf2.bindings
}

# use VN ID to create data source for CT for frontend network

data "apstra_datacenter_ct_virtual_network_single" "frontend_vn_storage" {
    vn_id = apstra_datacenter_virtual_network.frontend_vn_storage.id
    tagged = false
}

# create actual frontend CT for VNs now by attaching the primitive from the data source

resource "apstra_datacenter_connectivity_template" "frontend_ct2" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  name         = "Frontend_Storage_VLAN"
  description  = "Frontend storage untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.frontend_vn_storage.primitive
  ]
}

# Assign CTs to application points
#
# For each generic system type, gather graph IDs for all interfaces based on their tags assignments
# which point to the hosts
#
# Then create count loop using the actual count of each generic system type
# and then loop through list using count.index when assigning application point


#
# Assign the frontend CT
#

data "apstra_datacenter_interfaces_by_link_tag" "frontend_a100_links" {
    blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
    tags         = ["frontend_a100"]
}

resource "apstra_datacenter_connectivity_template_assignment" "frontend_assign_ct_a100" {
  count = apstra_rack_type.frontend_mgmt_ai.generic_systems.hgx-mgmt.count
  blueprint_id              = apstra_datacenter_blueprint.mgmt_bp.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.frontend_a100_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.frontend_ct1.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "frontend_h100_links" {
    blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
    tags         = ["frontend_h100"]
}

resource "apstra_datacenter_connectivity_template_assignment" "frontend_assign_ct_h100" {
  count = apstra_rack_type.frontend_mgmt_ai.generic_systems.dgx-mgmt.count
  blueprint_id              = apstra_datacenter_blueprint.mgmt_bp.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.frontend_h100_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.frontend_ct1.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "frontend_headend_links" {
    blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
    tags         = ["frontend_headend"]
}

resource "apstra_datacenter_connectivity_template_assignment" "frontend_assign_ct_headend" {
  count = apstra_rack_type.frontend_mgmt_ai.generic_systems.headend_servers.count
  blueprint_id              = apstra_datacenter_blueprint.mgmt_bp.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.frontend_headend_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.frontend_ct1.id
  ]
}

data "apstra_datacenter_interfaces_by_link_tag" "frontend_weka_links" {
    blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
    tags         = ["frontend_weka"]
}

resource "apstra_datacenter_connectivity_template_assignment" "frontend_assign_ct_weka" {
  count = apstra_rack_type.frontend_mgmt_weka.generic_systems.weka-storage.count
  blueprint_id              = apstra_datacenter_blueprint.mgmt_bp.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.frontend_weka_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.frontend_ct2.id
  ]
}
