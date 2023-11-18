#
# Instantiate a blueprints from the previously created templates
#


resource "apstra_datacenter_blueprint" "gpu_bp" {
  name        = "Backend GPU Fabric"
  template_id = var.all_qfx_backend ? apstra_template_rack_based.ai_cluster_gpus_medium.id : apstra_template_rack_based.ai_cluster_gpus_large.id
}

resource "apstra_datacenter_blueprint" "storage_bp" {
  name        = "Backend Storage Fabric"
  template_id = apstra_template_rack_based.ai_cluster_storage.id
}

resource "apstra_datacenter_blueprint" "mgmt_bp" {
  name        = "Frontend Management Fabric"
  template_id = apstra_template_rack_based.ai_cluster_mgmt.id
}

#
# Populate the blueprint ASNs and addressing from resource pools
#

locals {
  blueprints = [
    apstra_datacenter_blueprint.mgmt_bp,
    apstra_datacenter_blueprint.storage_bp,
    apstra_datacenter_blueprint.gpu_bp,
  ]

  asn_pool_roles = ["spine_asns", "leaf_asns"]
  first_asn      = 100
  asn_pool_size  = 100

  #
  # 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24 for the GPU fabric
  # 10.0.3.0/24, 10.0.4.0/24, 10.0.5.0/24 for the mgmt fabric
  # 10.0.6.0/24, 10.0.7.0/24, 10.0.8.0/24 for the storage fabric
  #
  ipv4_pool_roles      = ["spine_loopback_ips", "leaf_loopback_ips", "spine_leaf_link_ips"]
  ipv4_block           = "10.0.0.0/8"
  ipv4_pool_extra_bits = 16
}

resource "apstra_asn_pool" "all" {
  count = (length(local.blueprints) * length(local.asn_pool_roles))
  name = format("%s %s",
    local.blueprints[floor(count.index / length(local.asn_pool_roles))].name,
    replace(title(replace(local.asn_pool_roles[count.index % length(local.asn_pool_roles)], "_", " ")), "Asns", "ASNs"),
  )
  ranges = [
    {
      first = local.first_asn + (count.index * local.asn_pool_size)
      last  = local.first_asn + (count.index * local.asn_pool_size) + local.asn_pool_size - 1
    }
  ]
}

resource "apstra_datacenter_resource_pool_allocation" "asns" {
  count        = (length(local.blueprints) * length(local.asn_pool_roles))
  blueprint_id = local.blueprints[floor(count.index / length(local.asn_pool_roles))].id
  pool_ids     = [apstra_asn_pool.all[count.index].id]
  role         = local.asn_pool_roles[count.index % length(local.asn_pool_roles)]
}

resource "apstra_ipv4_pool" "all" {
  count = (length(local.blueprints) * length(local.ipv4_pool_roles))
  name = format("%s %s",
    local.blueprints[floor(count.index / length(local.ipv4_pool_roles))].name,
    replace(title(replace(local.ipv4_pool_roles[count.index % length(local.ipv4_pool_roles)], "_", " ")), "Ips", "IPs"),
  )
  subnets = [{ network = cidrsubnet(local.ipv4_block, local.ipv4_pool_extra_bits, count.index) }]
}

resource "apstra_datacenter_resource_pool_allocation" "ipv4" {
  count        = (length(local.blueprints) * length(local.ipv4_pool_roles))
  blueprint_id = local.blueprints[floor(count.index / length(local.ipv4_pool_roles))].id
  pool_ids     = [apstra_ipv4_pool.all[count.index].id]
  role         = local.ipv4_pool_roles[count.index % length(local.ipv4_pool_roles)]
}


#
# Assign interface map for spines
#
resource "apstra_datacenter_device_allocation" "frontend_spines" {
  count                    = 2
  blueprint_id             = apstra_datacenter_blueprint.mgmt_bp.id
  initial_interface_map_id = apstra_interface_map.ai_spine_32x400.id
  node_name                = "spine${count.index + 1}"
  # commenting out the deploy_mode as this will block the below BP deploy/commit
  # unless device system IDs are also provided which we will add later
  #deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "storage_spines" {
  count                    = 2
  blueprint_id             = apstra_datacenter_blueprint.storage_bp.id
  initial_interface_map_id = apstra_interface_map.ai_spine_32x400.id
  node_name                = "spine${count.index + 1}"
  #  deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "gpus_spines" {
  count                    = 2
  blueprint_id             = apstra_datacenter_blueprint.gpu_bp.id
  initial_interface_map_id = var.all_qfx_backend ? apstra_interface_map.ai_spine_64x400.id : apstra_interface_map.ai_spine_ptx10008_72x400.id
  node_name                = "spine${count.index + 1}"
  #  deploy_mode              = "deploy"
}

#
# Assign interface map for leafs
#
resource "apstra_datacenter_device_allocation" "frontend_leafs1" {
  blueprint_id             = apstra_datacenter_blueprint.mgmt_bp.id
  initial_interface_map_id = apstra_interface_map.ai_leaf_16x400_64x100.id
  node_name                = format("%s_001_leaf1", replace(lower(apstra_rack_type.frontend_mgmt_ai.name), "-", "_"))
  #  deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "frontend_leafs2" {
  blueprint_id             = apstra_datacenter_blueprint.mgmt_bp.id
  initial_interface_map_id = apstra_interface_map.ai_leaf_16x400_64x100.id
  node_name                = format("%s_001_leaf1", replace(lower(apstra_rack_type.frontend_mgmt_weka.name), "-", "_"))
  #  deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "storage_leafs1" {
  count                    = 2
  blueprint_id             = apstra_datacenter_blueprint.storage_bp.id
  initial_interface_map_id = apstra_interface_map.ai_leaf_16x400_32x200.id
  node_name                = format("%s_001_leaf%s", replace(lower(apstra_rack_type.storage_ai.name), "-", "_"), count.index + 1)
  #  deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "storage_leafs2" {
  count                    = 2
  blueprint_id             = apstra_datacenter_blueprint.storage_bp.id
  initial_interface_map_id = apstra_interface_map.ai_leaf_16x400_32x200.id
  node_name                = format("%s_001_leaf%s", replace(lower(apstra_rack_type.storage_weka.name), "-", "_"), count.index + 1)
  #  deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "gpu_leafs1" {
  count                    = 8
  blueprint_id             = apstra_datacenter_blueprint.gpu_bp.id
  initial_interface_map_id = apstra_interface_map.ai_lab_leaf_small.id
  node_name                = format("%s_001_leaf%s", replace(lower(apstra_rack_type.gpu_backend_sml.name), "-", "_"), count.index + 1)
  #  deploy_mode              = "deploy"
}

resource "apstra_datacenter_device_allocation" "gpu_leafs2" {
  count                    = 8
  blueprint_id             = apstra_datacenter_blueprint.gpu_bp.id
  initial_interface_map_id = apstra_interface_map.ai_lab_leaf_medium.id
  node_name                = format("%s_001_leaf%s", replace(lower(apstra_rack_type.gpu_backend_med.name), "-", "_"), count.index + 1)
  #  deploy_mode              = "deploy"
}



#
# Add configlets to the fabrics. We will assume the DLB configlet and DCQCN configlet
# are not necessary for the management fabric/blueprint.
#

resource "apstra_datacenter_configlet" "dlb_gpu" {
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  catalog_configlet_id = apstra_configlet.dlb.id
  condition            = var.all_qfx_backend ? "role in [\"leaf\", \"spine\"]" : "role in [\"leaf\"]"
}

resource "apstra_datacenter_configlet" "dlb_storage" {
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  catalog_configlet_id = apstra_configlet.dlb.id
  condition            = "role in [\"leaf\", \"spine\"]"
}

resource "apstra_datacenter_configlet" "dcqcn_gpu_spine" {
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  catalog_configlet_id = var.all_qfx_backend ? apstra_configlet.ai_spine_64x400_dcqcn.id : apstra_configlet.ai_spine_ptx10008_72x400_dcqcn.id
  condition            = "role in [\"spine\"]"
}

resource "apstra_datacenter_configlet" "dcqcn_storage_spine" {
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  catalog_configlet_id = apstra_configlet.ai_spine_32x400_dcqcn.id
  condition            = "role in [\"spine\"]"
}

resource "apstra_datacenter_configlet" "dcqcn_gpu_leaf_medium_dcqcn" {
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  catalog_configlet_id = apstra_configlet.ai_lab_leaf_medium_dcqcn.id
  condition            = "(\"gpu_medium\"in tags)"
}

resource "apstra_datacenter_configlet" "dcqcn_gpu_leaf_small_dcqcn" {
  blueprint_id         = apstra_datacenter_blueprint.gpu_bp.id
  catalog_configlet_id = apstra_configlet.ai_lab_leaf_small_dcqcn.id
  condition            = "(\"gpu_small\"in tags)"
}

resource "apstra_datacenter_configlet" "dcqcn_storage_leaf_16x400_32x200_dcqcn" {
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  catalog_configlet_id = apstra_configlet.ai_leaf_16x400_32x200_dcqcn.id
  condition            = "(\"storage_h100\"in tags)"
}

resource "apstra_datacenter_configlet" "dcqcn_storage_leaf_small_dcqcn" {
  blueprint_id         = apstra_datacenter_blueprint.storage_bp.id
  catalog_configlet_id = apstra_configlet.ai_lab_leaf_small_dcqcn.id
  condition            = "(\"storage_weka\"in tags)"
}

# Deploy and commit changes to frontend blueprint

# Ensure all dependencies are added here so that blueprint does not commit without
# these being met

resource "apstra_blueprint_deployment" "mgmt_bp_deploy" {
  blueprint_id = apstra_datacenter_blueprint.mgmt_bp.id
  depends_on = [
    apstra_tag.host_tags,
    apstra_datacenter_device_allocation.frontend_leafs1,
    apstra_datacenter_device_allocation.frontend_leafs2,
    apstra_datacenter_device_allocation.frontend_spines,
    apstra_datacenter_resource_pool_allocation.asns,
    apstra_datacenter_resource_pool_allocation.ipv4,
    apstra_datacenter_connectivity_template_assignment.frontend_assign_ct_headend,
    apstra_datacenter_connectivity_template_assignment.frontend_assign_ct_a100,
    apstra_datacenter_connectivity_template_assignment.frontend_assign_ct_h100,
    apstra_datacenter_connectivity_template_assignment.frontend_assign_ct_weka
  ]

  # Version is replaced using `text/template` method. Only predefined values
  # may be replaced with this syntax. USER is replaced using values from the
  # environment. Any environment variable may be specified this way.
  comment = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}

# deploy and commit backend bluprint 

resource "apstra_blueprint_deployment" "gpu_bp_deploy" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  depends_on = [
    apstra_tag.host_tags,
    apstra_datacenter_device_allocation.gpu_leafs1,
    apstra_datacenter_device_allocation.gpu_leafs2,
    apstra_datacenter_device_allocation.gpus_spines,
    apstra_datacenter_resource_pool_allocation.asns,
    apstra_datacenter_resource_pool_allocation.ipv4,
    apstra_datacenter_connectivity_template_assignment.gpu_small_assign_ct_a100,
    apstra_datacenter_connectivity_template_assignment.gpu_medium_assign_ct_a100,
    apstra_datacenter_connectivity_template_assignment.gpu_small_assign_ct_h100,
    apstra_datacenter_connectivity_template_assignment.gpu_medium_assign_ct_h100,
    apstra_datacenter_resource_pool_allocation.gpu_subnet_alloc,
    apstra_datacenter_configlet.dlb_gpu,
    apstra_datacenter_configlet.dcqcn_gpu_spine,
    apstra_datacenter_configlet.dcqcn_gpu_leaf_small_dcqcn,
    apstra_datacenter_configlet.dcqcn_gpu_leaf_medium_dcqcn
  ]

  # Version is replaced using `text/template` method. Only predefined values
  # may be replaced with this syntax. USER is replaced using values from the
  # environment. Any environment variable may be specified this way.
  comment = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}

# deploy and commit storage bluprint 

resource "apstra_blueprint_deployment" "storage_bp_deploy" {
  blueprint_id = apstra_datacenter_blueprint.storage_bp.id
  depends_on = [
    apstra_tag.host_tags,
    apstra_datacenter_device_allocation.storage_leafs1,
    apstra_datacenter_device_allocation.storage_leafs2,
    apstra_datacenter_device_allocation.storage_spines,
    apstra_datacenter_resource_pool_allocation.asns,
    apstra_datacenter_resource_pool_allocation.ipv4,
    apstra_datacenter_connectivity_template_assignment.storage_assign_ct_weka,
    apstra_datacenter_connectivity_template_assignment.storage_assign_ct_h100,
    apstra_datacenter_connectivity_template_assignment.storage_assign_ct_a100,
    apstra_datacenter_resource_pool_allocation.storage_subnet_alloc,
    apstra_datacenter_configlet.dlb_storage,
    apstra_datacenter_configlet.dcqcn_storage_spine,
    apstra_datacenter_configlet.dcqcn_storage_leaf_16x400_32x200_dcqcn,
    apstra_datacenter_configlet.dcqcn_storage_leaf_small_dcqcn
  ]

  # Version is replaced using `text/template` method. Only predefined values
  # may be replaced with this syntax. USER is replaced using values from the
  # environment. Any environment variable may be specified this way.
  comment = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
}
