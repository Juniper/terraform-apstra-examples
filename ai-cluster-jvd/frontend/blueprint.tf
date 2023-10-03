# find interface map ID for LD AOS-24x100+8x400-1

data "apstra_interface_map" "im_details" {
    name = "Juniper_QFX5130-32CD__AOS-24x100_8x400-1"
}

# create local grouping of leafs and spines and their IMs

locals {
    leafs = {
        ai_frontend_001_leaf1 = {
            initial_interface_map_id = data.apstra_interface_map.im_details.id
        }
        ai_frontend_001_leaf2 = {
            initial_interface_map_id = data.apstra_interface_map.im_details.id
        }
    }
    spines = {
        spine1 = {
            initial_interface_map_id = data.apstra_interface_map.im_details.id
        }
        spine2 = {
            initial_interface_map_id = data.apstra_interface_map.im_details.id
        }
    }
}

# create blueprint with template as input

resource "apstra_datacenter_blueprint" "frontend_blueprint" {
    name        = "AI_Frontend"
    template_id = apstra_template_rack_based.frontend_template.id
}

# assign interface maps to devices in blueprint

resource "apstra_datacenter_device_allocation" "assigned_leafs" {
  for_each                 = local.leafs
  blueprint_id             = apstra_datacenter_blueprint.frontend_blueprint.id
  initial_interface_map_id = each.value["initial_interface_map_id"]
  node_name                = each.key
}

resource "apstra_datacenter_device_allocation" "assigned_spines" {
  for_each                 = local.spines
  blueprint_id             = apstra_datacenter_blueprint.frontend_blueprint.id
  initial_interface_map_id = each.value["initial_interface_map_id"]
  node_name                = each.key
}

# assign resources in blueprint

resource "apstra_datacenter_resource_pool_allocation" "spine_asns" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    role         = "spine_asns"
    pool_ids     = [apstra_asn_pool.asn_pool.id]
}

resource "apstra_datacenter_resource_pool_allocation" "leaf_asns" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    role         = "leaf_asns"
    pool_ids     = [apstra_asn_pool.asn_pool.id]
}

resource "apstra_datacenter_resource_pool_allocation" "p2p_interfaces" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    role         = "spine_leaf_link_ips"
    pool_ids     = [apstra_ipv4_pool.p2p.id]
}

resource "apstra_datacenter_resource_pool_allocation" "leaf_loopbacks" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    role         = "leaf_loopback_ips"
    pool_ids     = [apstra_ipv4_pool.loopback.id]
}

resource "apstra_datacenter_resource_pool_allocation" "spine_loopbacks" {
    blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
    role         = "spine_loopback_ips"
    pool_ids     = [apstra_ipv4_pool.loopback.id]
}

# deploy and commit changes to blueprint

# ensure all dependencies are added here so that blueprint does not commit without
# these being met

resource "apstra_blueprint_deployment" "frontend_deploy" {
  blueprint_id = apstra_datacenter_blueprint.frontend_blueprint.id
  depends_on = [
    apstra_tag.host_tags,
    apstra_datacenter_device_allocation.assigned_leafs,
    apstra_datacenter_device_allocation.assigned_spines,
    apstra_datacenter_resource_pool_allocation.spine_asns,
    apstra_datacenter_resource_pool_allocation.leaf_asns,
    apstra_datacenter_resource_pool_allocation.p2p_interfaces,
    apstra_datacenter_resource_pool_allocation.leaf_loopbacks,
    apstra_datacenter_resource_pool_allocation.spine_loopbacks,
    apstra_datacenter_virtual_network.a100_vn,
    apstra_datacenter_virtual_network.h100_vn,
    apstra_datacenter_virtual_network.headend_vn,
    apstra_datacenter_virtual_network.storage_vn,
    apstra_datacenter_connectivity_template_assignment.assign_ct_a100,
    apstra_datacenter_connectivity_template_assignment.assign_ct_h100,
    apstra_datacenter_connectivity_template_assignment.assign_ct_headend,
    apstra_datacenter_connectivity_template_assignment.assign_ct_storage
  ]

  # Version is replaced using `text/template` method. Only predefined values
  # may be replaced with this syntax. USER is replaced using values from the
  # environment. Any environment variable may be specified this way.
  comment      = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}