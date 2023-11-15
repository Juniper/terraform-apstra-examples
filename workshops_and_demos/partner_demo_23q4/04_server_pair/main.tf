# tell terraform which plugins we'll be using (the Apstra plugin)
terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.42.0"
    }
  }
}

# configure the Apstra plugin (credentials and URL are in env vars in this case)
provider "apstra" {
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}

# We'll need the blueprint ID, so grab some breadcrumbs from the project which created the blueprint
data "terraform_remote_state" "setup_fabric" {
  backend = "local"
  config  = { path = "../01_setup_fabric/terraform.tfstate" }
}

# We'll need the routing zone ID, so grab some breadcrumbs from the project which created the routing_zone
data "terraform_remote_state" "vnets" {
  backend = "local"
  config  = { path = "../03_vnets/terraform.tfstate" }
}

# The new servers will be attached to leaf switches in compute rack 002 -- look up their details
data "apstra_datacenter_system" "rack2_leafs" {
  count        = 2 // leaf 1 and leaf 2
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name         = "aaa_compute_002_leaf${count.index + 1}"
}

# Create application XYZ server 1
resource "apstra_datacenter_generic_system" "xyz_1" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name         = "XYZ server 1"
  links = [
    {
      lag_mode                      = "lacp_active"
      target_switch_id              = data.apstra_datacenter_system.rack2_leafs[0].id // leaf 1
      target_switch_if_name         = "xe-0/0/15"
      target_switch_if_transform_id = 2
      group_label                   = "bond0"
      tags                          = ["app xyz", "xyz 1"]
    },
    {
      lag_mode                      = "lacp_active"
      target_switch_id              = data.apstra_datacenter_system.rack2_leafs[1].id // leaf 2
      target_switch_if_name         = "xe-0/0/15"
      target_switch_if_transform_id = 2
      group_label                   = "bond0"
      tags                          = ["app xyz", "xyz 1"]
    },
  ]
}

# Create application XYZ server 2
resource "apstra_datacenter_generic_system" "xyz_2" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name         = "XYZ server 2"
  links = [
    {
      lag_mode                      = "lacp_active"
      target_switch_id              = data.apstra_datacenter_system.rack2_leafs[0].id // leaf 1
      target_switch_if_name         = "xe-0/0/16"
      target_switch_if_transform_id = 2
      group_label                   = "bond0"
      tags                          = ["app xyz", "xyz 2"]
    },
    {
      lag_mode                      = "lacp_active"
      target_switch_id              = data.apstra_datacenter_system.rack2_leafs[1].id // leaf 2
      target_switch_if_name         = "xe-0/0/16"
      target_switch_if_transform_id = 2
      group_label                   = "bond0"
      tags                          = ["app xyz", "xyz 2"]
    },
  ]
}

# bindings are the association between virtual networks and switches. The
# binding constructor data source is a shortcut for handing dependencies with
# ESI and MLAG switch pairs (switches must agree) and Access switches (parent
# leaf switches must be included)
data "apstra_datacenter_virtual_network_binding_constructor" "rack2_leafs" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  switch_ids   = data.apstra_datacenter_system.rack2_leafs[*].id
}

# Create frontend and backend networks for the XYZ app servers
resource "apstra_datacenter_virtual_network" "app_xyz_networks" {
  for_each                     = toset(["Frontend", "Backend"])
  name                         = "XYZ_${each.key}"
  blueprint_id                 = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  type                         = "vxlan"
  routing_zone_id              = data.terraform_remote_state.vnets.outputs["routing_zone_id"]
  ipv4_connectivity_enabled    = true
  ipv4_virtual_gateway_enabled = true
  bindings                     = data.apstra_datacenter_virtual_network_binding_constructor.rack2_leafs.bindings
}

# Create a Connectivity Tempalte for the XYZ app servers.
# This starts with defining the VLANs.
data "apstra_datacenter_ct_virtual_network_multiple" "xyz_app_server" {
  name          = "XYZ VLANs"
  tagged_vn_ids = [for k, v in apstra_datacenter_virtual_network.app_xyz_networks : v.id]
}

# Create a Connectivity Tempalte for the XYZ app servers.
# CT creation cites the multiple VLAN data above.
resource "apstra_datacenter_connectivity_template" "xyz" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  name         = "XYZ VLAN handoff"
  description  = "${length(apstra_datacenter_virtual_network.app_xyz_networks)} VLANs for XYZ servers"
  primitives   = [data.apstra_datacenter_ct_virtual_network_multiple.xyz_app_server.primitive]
}

# Find all of the links to xyz server 1
data "apstra_datacenter_interfaces_by_link_tag" "xyz_1" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  tags         = ["xyz 1"] // same value as used for link tags in server creation resource
  depends_on   = [ apstra_datacenter_generic_system.xyz_1 ]
}

# Find all of the links to xyz server 2
data "apstra_datacenter_interfaces_by_link_tag" "xyz_2" {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  tags         = ["xyz 2"] // same value as used for link tags in server creation resource
  depends_on   = [ apstra_datacenter_generic_system.xyz_2 ]
}

# Apply the connectivity template to xyz server 1
resource "apstra_datacenter_connectivity_template_assignment" "xyz_1" {
  blueprint_id         = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  application_point_id = one(data.apstra_datacenter_interfaces_by_link_tag.xyz_1.ids)
  connectivity_template_ids = [ apstra_datacenter_connectivity_template.xyz.id ]
}

# Apply the connectivity template to xyz server 2
resource "apstra_datacenter_connectivity_template_assignment" "xyz_2" {
  blueprint_id         = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
  application_point_id = one(data.apstra_datacenter_interfaces_by_link_tag.xyz_2.ids)
  connectivity_template_ids = [ apstra_datacenter_connectivity_template.xyz.id ]
}
