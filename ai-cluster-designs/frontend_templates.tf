
#
# Frontend management fabrics are generally one port of 100GE per server,
# regardless of the server GPU class. These commonly use EVPN-VXLAN as well,
# so include that instead of the IP Fabric (static overlay control protocol)
#

locals {
  leaf_definition_16x400_32x100_4spine_links = {
    logical_device_id   = apstra_logical_device.AI-Leaf_16x400_32x100.id
    spine_link_count    = 4
    spine_link_speed    = "400G"
  }
}

# Frontend rack of 100GE access to DGX  servers with 1x100G mgmt port
resource "apstra_rack_type" "AI_frontend_mgmt_32_1x100G_4spine_links" {
  name        = "AI mgmt32 1x100-4"
  description = "AI frontend management rack for 1x100GE connectivity for 32 DGX servers. 4 spine links"
  fabric_connectivity_design = "l3clos"
  leaf_switches = {
    Leaf1 = local.leaf_definition_16x400_32x100_4spine_links,
  }
  generic_systems = {
    DGX_Server_Mgmt = {
      count             = 32
      logical_device_id = apstra_logical_device.AI-Mgmt_1x100G.id
      links = {
        link1 = {
          speed              = "100G"
          target_switch_name = "Leaf1"
        },
      }
    }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_64_DGX" {
  name                     = "AI Cluster 64 DGX Server Frontend Management Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "evpn"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_frontend_mgmt_32_1x100G_4spine_links.id)    = { count = 2 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_128_DGX" {
  name                     = "AI Cluster 128 DGX Server Frontend Management Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "evpn"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_frontend_mgmt_32_1x100G_4spine_links.id)    = { count = 4 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_256_DGX" {
  name                     = "AI Cluster 256 DGX Server Frontend Management Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "evpn"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_frontend_mgmt_32_1x100G_4spine_links.id)    = { count = 8 }
  }
}
