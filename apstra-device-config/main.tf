terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = ">= 0.56.0"
    }
  }
}

provider "apstra" {
  # URL and credentials can be supplied using the "url" parameter in this file.
  # url = "https://admin:password@ipaddress:port"
  #
  # ...or using the environment variable APSTRA_URL.
  #
  # If Username or Password are not embedded in the URL, the provider will look
  # for them in the APSTRA_USER and APSTRA_PASS environment variables.
  #
  tls_validation_disabled = true  # CloudLabs doesn't present a valid TLS cert
  blueprint_mutex_enabled = false # Don't attempt worry about competing clients
  experimental            = true
}

data "apstra_datacenter_blueprint" "a" {
  name = "a"
}

# filter the devices to find only the switches. (no generic systems)
data "apstra_datacenter_systems" "switches" {
  blueprint_id = data.apstra_datacenter_blueprint.a.id
  filters = [
    {
      system_type = "switch"
    }
  ]
}

# populate the data source for all of the switches.
data "apstra_datacenter_system" "switches" {
  for_each = data.apstra_datacenter_systems.switches.ids
  blueprint_id = data.apstra_datacenter_blueprint.a.id
  id = each.key
  }
#create system id : switch label map
locals {
  repo_dir =  "/tmp/repo"
  managed_system_ids = { for i in data.apstra_datacenter_system.switches : i.attributes.system_id => i.attributes.label if i.attributes.system_id != null }
}

# Collect the device config info
data "apstra_device_config" "switches" {
  for_each = local.managed_system_ids
  system_id = each.key
}

# use the last_boot_time information :)
output "uptime_output" {
  description = "uptime"
  value = { for k,v in local.managed_system_ids: v => data.apstra_device_config.switches[k].last_boot_time }
}

#Extract the config from each device and place them in some files.
resource "local_file" "all_configs" {
  for_each = local.managed_system_ids
  filename = format("${local.repo_dir}/%s.cfg", each.value)
  content = data.apstra_device_config.switches[each.key].config_actual
}

#perform the git init
resource "terraform_data" "git_repo" {
  depends_on = [local_file.all_configs]
  provisioner "local-exec" {
    working_dir = local.repo_dir
    command = "git init"
  }
}

#Perform the git add
resource "terraform_data" "git_add" {
  depends_on = [terraform_data.git_repo]
  triggers_replace = {for k,v in local.managed_system_ids: format("${local.repo_dir}/%s.cfg",v) => sha256(data.apstra_device_config.switches[k].config_actual)}
  provisioner "local-exec" {
    working_dir = local.repo_dir
    command = "git add ."
  }
}

#Perform the git commit
resource "terraform_data" "git_commit" {
  depends_on = [terraform_data.git_add]
  provisioner "local-exec" {
    working_dir = local.repo_dir
    command = "git commit -m ${timestamp()}"
  }
}
