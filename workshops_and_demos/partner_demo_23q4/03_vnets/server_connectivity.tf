data "apstra_datacenter_interfaces_by_link_tag" "hypervisor_ports" {
  blueprint_id = local.blueprint_id
  tags         = ["hypervisor"]
}

data "apstra_datacenter_interfaces_by_link_tag" "kubernetes_ports" {
  blueprint_id = local.blueprint_id
  tags         = ["kubernetes"]
}

data "apstra_datacenter_ct_virtual_network_multiple" "hypervisor" {
  name = "${length(apstra_datacenter_virtual_network.hypervisor)} VLANs for Hypervisor Nodes"
  tagged_vn_ids = apstra_datacenter_virtual_network.hypervisor[*].id
}

data "apstra_datacenter_ct_virtual_network_multiple" "kubernetes" {
  name = "${length(apstra_datacenter_virtual_network.kubernetes)} VLANs for Kubernetes Nodes"
  tagged_vn_ids = apstra_datacenter_virtual_network.kubernetes[*].id
}

resource "apstra_datacenter_connectivity_template" "hypervisor_vlans" {
  blueprint_id = local.blueprint_id
  name         = "Hypervisor VLANs"
  description  = "802.1Q handoff to Hypervisor nodes"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_multiple.hypervisor.primitive
  ]
}

resource "apstra_datacenter_connectivity_template" "kubernetes_vlans" {
  blueprint_id = local.blueprint_id
  name         = "Kubernetes VLANs"
  description  = "802.1Q handoff to Kubernetes nodes"
  primitives   = [
    data.apstra_datacenter_ct_virtual_network_multiple.kubernetes.primitive
  ]
}

resource "apstra_datacenter_connectivity_template_assignment" "hypervisor_ports" {
  for_each = data.apstra_datacenter_interfaces_by_link_tag.hypervisor_ports.ids
  blueprint_id              = local.blueprint_id
  application_point_id      = each.key
  connectivity_template_ids = [ apstra_datacenter_connectivity_template.hypervisor_vlans.id ]
}

resource "apstra_datacenter_connectivity_template_assignment" "kubernetes_ports" {
  for_each = data.apstra_datacenter_interfaces_by_link_tag.kubernetes_ports.ids
  blueprint_id              = local.blueprint_id
  application_point_id      = each.key
  connectivity_template_ids = [ apstra_datacenter_connectivity_template.kubernetes_vlans.id ]
}
