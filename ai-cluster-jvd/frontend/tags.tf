#create local set to loop over and create tags

locals {
  hosts = toset([
    "a100",
    "storage",
    "h100",
    "headend"
  ])
}

# description is important otherwise TF thinks tags must be updated
# in place every time

resource "apstra_tag" "host_tags" {
    for_each    = local.hosts
    name        = each.key
    description = each.key
}