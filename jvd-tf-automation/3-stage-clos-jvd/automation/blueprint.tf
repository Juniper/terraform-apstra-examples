# create blueprint with template as input

resource "apstra_datacenter_blueprint" "dc1_blueprint" {
    name        = "dc1"
    template_id = apstra_template_rack_based.dc1_template.id
}

# assign interface maps and deploy mode for devices

// this is done recursively with a 'for_each' construct
// we loop through all devices declared in locals, find the system ID and node name
// that Apstra would assign to it, and then set its deploy mode to 'deploy'

resource "apstra_datacenter_device_allocation" "devices" {
    depends_on = [apstra_managed_device_ack.device]
    for_each = local.devices
    blueprint_id     = apstra_datacenter_blueprint.dc1_blueprint.id
    initial_interface_map_id = apstra_interface_map.vJunos_IM.id
    node_name        = each.value.label
    device_key       = apstra_managed_device.device[each.key].system_id
    deploy_mode      = "deploy"
}

# assign ASN and IP pools

resource "apstra_datacenter_resource_pool_allocation" "spine_asns" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    role         = "spine_asns"
    pool_ids     = [apstra_asn_pool.asn_pool.id]
}

resource "apstra_datacenter_resource_pool_allocation" "leaf_asns" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    role         = "leaf_asns"
    pool_ids     = [apstra_asn_pool.asn_pool.id]
}

resource "apstra_datacenter_resource_pool_allocation" "p2p_interfaces" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    role         = "spine_leaf_link_ips"
    pool_ids     = [apstra_ipv4_pool.p2p.id]
}

resource "apstra_datacenter_resource_pool_allocation" "leaf_loopbacks" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    role         = "leaf_loopback_ips"
    pool_ids     = [apstra_ipv4_pool.loopback.id]
}

resource "apstra_datacenter_resource_pool_allocation" "spine_loopbacks" {
    blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id
    role         = "spine_loopback_ips"
    pool_ids     = [apstra_ipv4_pool.loopback.id]
}

resource "apstra_blueprint_deployment" "dc1_deploy" {
  blueprint_id = apstra_datacenter_blueprint.dc1_blueprint.id

  #ensure that deployment doesn't run before build errors are resolved
  
  depends_on = [
    apstra_datacenter_device_allocation.devices,
    apstra_datacenter_resource_pool_allocation.spine_asns,
    apstra_datacenter_resource_pool_allocation.leaf_asns,
    apstra_datacenter_resource_pool_allocation.p2p_interfaces,
    apstra_datacenter_resource_pool_allocation.leaf_loopbacks,
    apstra_datacenter_resource_pool_allocation.spine_loopbacks,
    apstra_datacenter_routing_zone.blue,
    apstra_datacenter_routing_zone.red,
    apstra_datacenter_resource_pool_allocation.blue_rz_loopback,
    apstra_datacenter_resource_pool_allocation.red_rz_loopback,
    apstra_datacenter_virtual_network.dc1_vn1_blue,
    apstra_datacenter_virtual_network.dc1_vn2_blue,
    apstra_datacenter_virtual_network.dc1_vn1_red,
    apstra_datacenter_virtual_network.dc1_vn2_red,
    apstra_tag.host_tags,
    apstra_datacenter_connectivity_template.dc1_vn1_red_ct,
    apstra_datacenter_connectivity_template.dc1_vn2_red_ct,
    apstra_datacenter_connectivity_template.dc1_vn1_blue_ct,
    apstra_datacenter_connectivity_template.dc1_vn2_blue_ct,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn1_red_h1,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn1_red_h5,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn1_red_h7,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn1_red_h9,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn2_red_h3,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn1_blue_h2,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn2_blue_h4,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn2_blue_h6,
    apstra_datacenter_connectivity_template_assignment.assign_ct_dc1_vn2_blue_h8
  ]

  # Version is replaced using `text/template` method. Only predefined values
  # may be replaced with this syntax. USER is replaced using values from the
  # environment. Any environment variable may be specified this way.
  comment      = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}