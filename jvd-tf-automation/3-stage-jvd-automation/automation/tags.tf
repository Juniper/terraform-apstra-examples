locals {
  hosts = toset([
    "h1",
    "h2",
    "h3",
    "h4",
    "h5",
    "h6",
    "h7",
    "h8",
    "h9"
  ])
}

resource "apstra_tag" "host_tags" {
    for_each    = local.hosts
    name        = each.key
}