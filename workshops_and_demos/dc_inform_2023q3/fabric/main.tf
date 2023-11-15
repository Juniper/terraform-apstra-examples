module "fabric" {
  source = "../_modules/fabric"
}

resource "null_resource" "force_redeploy" {
  depends_on = [module.fabric]
  triggers   = { fabric_staging_revision = module.fabric.staging_revision }
}

resource "apstra_blueprint_deployment" "dc_1" {
  blueprint_id = module.fabric.blueprint_id
  comment      = "Deployment by Terraform {{.TerraformVersion}}, Apstra provider {{.ProviderVersion}}, User $USER."
  depends_on   = [null_resource.force_redeploy]
}
