terraform {
  required_providers {
    apstra = {
      source = "Juniper/apstra"
    }
  }
}

provider "apstra" {
    tls_validation_disabled  = true
    blueprint_mutex_disabled = true
  }

data "apstra_property_sets" "all" {}

# Loop over Property Set IDs, creating an instance of `apstra_property_set` for each.
data "apstra_property_set" "each_ps" {
  for_each = toset(data.apstra_property_sets.all.ids)
  id       = each.value
}
locals {
  payload = jsonencode({
    value_str = "str"
    value_int = 42
    value_json = {
      inner_value_str = "innerstr"
      inner_value_int = 4242
    }
  })
}
resource "apstra_property_set" "r" {
  name = "TF Property Set 1234567"
  data = local.payload
}
# Output the property set report
output "apstra_property_set_report" {
  value = { for k, v in data.apstra_property_set.each_ps : k => {
    name = v.name
    data = jsondecode(v.data)
  } }
}

output "new_property_set" {
  value = resource.apstra_property_set.r
}
