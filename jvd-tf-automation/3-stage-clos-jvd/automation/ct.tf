# create a data source for respective VLANs first
# use tolist() because the data source returns a set. since we expect just one ID
# convert to a list using tolist() and then access the ID via index of 0

data "apstra_datacenter_ct_virtual_network_single" "dc1_vn1_red_vlan" {
    vn_id = tolist(data.apstra_datacenter_virtual_networks.dc1_vn1_red.ids)[0]
    tagged = false
}

data "apstra_datacenter_ct_virtual_network_single" "dc1_vn2_red_vlan" {
  vn_id  = tolist(data.apstra_datacenter_virtual_networks.dc1_vn2_red.ids)[0]
  tagged = false
}

data "apstra_datacenter_ct_virtual_network_single" "dc1_vn1_blue_vlan" {
  vn_id  = tolist(data.apstra_datacenter_virtual_networks.dc1_vn1_blue.ids)[0]
  tagged = false
}

data "apstra_datacenter_ct_virtual_network_single" "dc1_vn2_blue_vlan" {
  vn_id  = tolist(data.apstra_datacenter_virtual_networks.dc1_vn2_blue.ids)[0]
  tagged = false
}

# example of returned data from data source

# > data.apstra_datacenter_ct_virtual_network_single.dc1_vn1_red_vlan
# {
#   "child_primitives" = toset(null) /* of string */
#   "name" = tostring(null)
#   "primitive" = "{\"type\":\"AttachSingleVLAN\",\"label\":\"\",\"data\":{\"vn_id\":\"wHLslkbBZdBiIi0tObo\",\"tagged\":false}}"
#   "tagged" = false
#   "vn_id" = "wHLslkbBZdBiIi0tObo"
# }

# create actual CT for this now by attaching the primitive from the data source

resource "apstra_datacenter_connectivity_template" "dc1_vn1_red_ct" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  name         = "dc1_vn1_red_vlan"
  description  = "DC1 VN1 Red untagged"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.dc1_vn1_red_vlan.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "dc1_vn2_red_ct" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  name         = "dc1_vn2_red_vlan"
  description  = "DC1 VN2 Red untagged"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.dc1_vn2_red_vlan.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "dc1_vn1_blue_ct" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  name         = "dc1_vn1_blue_vlan"
  description  = "DC1 VN1 Blue untagged"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.dc1_vn1_blue_vlan.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "dc1_vn2_blue_ct" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
  name         = "dc1_vn2_blue_vlan"
  description  = "DC1 VN2 Blue untagged"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_single.dc1_vn2_blue_vlan.primitive
  ]
}

# gather graph IDs for all interfaces based on their tags assignments 
# which point to the hosts

data "apstra_datacenter_interfaces_by_link_tag" "h1_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h1"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h2_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h2"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h3_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h3"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h4_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h4"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h5_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h5"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h6_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h6"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h7_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h7"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h8_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h8"]
}
data "apstra_datacenter_interfaces_by_link_tag" "h9_link" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    tags         = ["h9"]
}

# data "apstra_datacenter_interfaces_by_link_tag" "all" {
#   count = 9
#   blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
#   tags         = ["h${count.index+1}"]
# }

# assign CT to application points i.e. the IDs that were determined from previous
# data source that found interfaces by tags

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn1_red_h1" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h1_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn1_red_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn1_red_h5" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h5_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn1_red_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn1_red_h7" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h7_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn1_red_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn1_red_h9" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h9_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn1_red_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn2_red_h3" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h3_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn2_red_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn1_blue_h2" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h2_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn1_blue_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn2_blue_h4" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h4_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn2_blue_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn2_blue_h6" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h6_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn2_blue_ct.id
    ]
}

resource "apstra_datacenter_connectivity_template_assignment" "assign_ct_dc1_vn2_blue_h8" {
  blueprint_id              = apstra_datacenter_blueprint.dc1_blueprint.id
  application_point_id      = one(data.apstra_datacenter_interfaces_by_link_tag.h8_link.ids)
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.dc1_vn2_blue_ct.id
    ]
}