#
# Setup the backend storage fabric networking with L3 routing only
#

# Get ID of default routing zone for this

data "apstra_datacenter_routing_zone" "storage_default_rz" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  name           = "default"
}

# Create IP Link data source for CT for storage L3 connections down to GPU Storage links and Weka Storage

data "apstra_datacenter_ct_ip_link" "l3_to_storage" {
  routing_zone_id      = data.apstra_datacenter_routing_zone.storage_default_rz.id
  ipv4_addressing_type = "numbered"
  ipv6_addressing_type = "none"
}

# Create the L3 IP Link CT by attaching primitive from data source

resource "apstra_datacenter_connectivity_template" "storage_l3_ct" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  name         = "L3_to_Storage"
  description  = "L3 link to Storage nodes for IP connectivity in IP Fabric"
  primitives   = [
    data.apstra_datacenter_ct_ip_link.l3_to_storage.primitive
  ]
}

#
# Assign Storage CT
#

data "apstra_datacenter_interfaces_by_link_tag" "storage_weka_links" {
    blueprint_id = apstra_datacenter_blueprint.storage_bp.id
    tags         = ["storage_weka"]
}

resource "apstra_datacenter_connectivity_template_assignment" "storage_assign_ct_weka" {
  count = apstra_rack_type.storage_weka.generic_systems.weka-storage.count
  blueprint_id              = apstra_datacenter_blueprint.storage_bp.id
  application_point_id      = tolist(data.apstra_datacenter_interfaces_by_link_tag.storage_weka_links.ids)[count.index]
  connectivity_template_ids = [
    apstra_datacenter_connectivity_template.storage_l3_ct.id
  ]
}
