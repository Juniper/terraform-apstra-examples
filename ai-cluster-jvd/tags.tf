# create local set to loop over and create tags

locals {
  hosts = toset([
    "frontend",
    "frontend_a100",
    "frontend_h100",
    "frontend_weka",
    "frontend_headend",
    "gpu",
    "gpu_small", // 5220 leaf
    "gpu_medium", //5230 leaf
    "gpu_a100",
    "gpu_h100",
    "storage",
    "storage_a100",
    "storage_h100",
    "storage_weka"
  ])
}

# description is important otherwise TF thinks tags must be updated
# in place every time with an empty string

resource "apstra_tag" "host_tags" {
    for_each    = local.hosts
    name        = each.key
    description = each.key
}