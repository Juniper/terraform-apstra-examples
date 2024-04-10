data "terraform_remote_state" "setup_fabric" {
  backend = "local"
  config = {
    path = "../01_setup_fabric/terraform.tfstate"
  }
}

locals {
  blueprint_id = data.terraform_remote_state.setup_fabric.outputs["blueprint_id"]
}

data "apstra_datacenter_systems" "leafs" {
  blueprint_id = local.blueprint_id
  filters = [
    {
      role        = "leaf"
      system_type = "switch"
    }
  ]
}

data "apstra_datacenter_virtual_network_binding_constructor" "example" {
  blueprint_id = local.blueprint_id
  switch_ids   = data.apstra_datacenter_systems.leafs.ids
}

locals {
  bindings = data.apstra_datacenter_virtual_network_binding_constructor.example.bindings
}
