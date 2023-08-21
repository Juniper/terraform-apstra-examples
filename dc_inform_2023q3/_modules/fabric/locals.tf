locals {
  template_id = "L2_Virtual_EVPN"
  interface_maps = {
    spine1               = "Juniper_vQFX__AOS-7x10-Spine"
    spine2               = "Juniper_vQFX__AOS-7x10-Spine"
    l2_virtual_001_leaf1 = "Juniper_vQFX__AOS-7x10-Leaf"
    l2_virtual_002_leaf1 = "Juniper_vQFX__AOS-7x10-Leaf"
    l2_virtual_003_leaf1 = "Juniper_vQFX__AOS-7x10-Leaf"
    l2_virtual_004_leaf1 = "Juniper_vQFX__AOS-7x10-Leaf"
  }
}