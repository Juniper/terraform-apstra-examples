# use VN ID to create data source for CT

data "apstra_datacenter_ct_virtual_network_single" "a100_vn" {
    vn_id = apstra_datacenter_virtual_network.a100_vn.id
    tagged = false
}

data "apstra_datacenter_ct_virtual_network_single" "h100_vn" {
    vn_id = apstra_datacenter_virtual_network.h100_vn.id
    tagged = false
}

data "apstra_datacenter_ct_virtual_network_single" "headend_vn" {
    vn_id = apstra_datacenter_virtual_network.headend_vn.id
    tagged = false
}

data "apstra_datacenter_ct_virtual_network_single" "storage_vn" {
    vn_id = apstra_datacenter_virtual_network.storage_vn.id
    tagged = false
}

# create actual CT for these now by attaching the primitive from the data source

resource "apstra_datacenter_connectivity_template" "a100_ct" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  name         = "A100_VLAN"
  description  = "A100 untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.a100_vn.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "h100_ct" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  name         = "H100_VLAN"
  description  = "H100 untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.h100_vn.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "headend_ct" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  name         = "Headend_VLAN"
  description  = "Headend untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.headend_vn.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "storage_ct" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  name         = "Storage_VLAN"
  description  = "Storage untagged VLAN"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.storage_vn.primitive
  ]
}

# gather graph IDs for all interfaces based on their tags assignments
# which point to the hosts

data "apstra_datacenter_interfaces_by_link_tag" "a100" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    tags         = ["a100"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h100" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    tags         = ["h100"]
}
data "apstra_datacenter_interfaces_by_link_tag" "headend" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    tags         = ["headend"]
}
data "apstra_datacenter_interfaces_by_link_tag" "storage" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    tags         = ["storage"]
}

# assign CT to application points

# create count loop using the actual count of each generic system type
# and then loop through list using count.index when assigning application point

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_a100" {
  count = apstra_rack_type.frontend_rack.generic_systems.A100.count
  blueprint_id              = apstra_datacenter_blueprint.frontend_blueprint.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.a100.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.a100_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_h100" {
  count = apstra_rack_type.frontend_rack.generic_systems.H100.count
  blueprint_id              = apstra_datacenter_blueprint.frontend_blueprint.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.h100.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.h100_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_headend" {
  count = apstra_rack_type.frontend_rack.generic_systems.Headend_Servers.count
  blueprint_id              = apstra_datacenter_blueprint.frontend_blueprint.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.headend.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.headend_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_storage" {
  count = apstra_rack_type.frontend_rack.generic_systems.Storage.count
  blueprint_id              = apstra_datacenter_blueprint.frontend_blueprint.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.storage.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.storage_ct.id
    ]
}