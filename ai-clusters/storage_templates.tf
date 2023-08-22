

resource "apstra_template_rack_based" "AI_Cluster_64_DGX-A100_Storage" {
  name                     = "AI Cluster 64 DGX-A100 (512 GPUs) Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_strg_32_1x200G_8spine_links.id)    = { count = 2 }
    (apstra_rack_type.AI_weka_16_2x200G_8spine_links.id)    = { count = 2 }
  }
}


resource "apstra_template_rack_based" "AI_Cluster_64_DGX-H100_Storage" {
  name                     = "AI Cluster 64 DGX-H100 (512 GPUs) Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 4
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_strg_16_1x400G_4spine_links.id)    = { count = 4 }
    (apstra_rack_type.AI_weka_16_2x200G_4spine_links.id)    = { count = 4 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_128_DGX-A100_Storage" {
  name                     = "AI Cluster 128 DGX-A100 (1024 GPUs) Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 4
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_strg_32_1x200G_4spine_links.id)    = { count = 4 }
    (apstra_rack_type.AI_weka_16_2x200G_4spine_links.id)    = { count = 4 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_128_DGX-H100_Storage" {
  name                     = "AI Cluster 128 DGX-H100 (1024 GPUs) Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 8
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_strg_16_1x400G_2spine_links.id)    = { count = 8 }
    (apstra_rack_type.AI_weka_16_2x200G_2spine_links.id)    = { count = 8 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_256_DGX-A100_Storage" {
  name                     = "AI Cluster 256 DGX-A100 (2048 GPUs) Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 8
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_strg_32_1x200G_2spine_links.id)    = { count = 4 }
    (apstra_rack_type.AI_weka_16_2x200G_2spine_links.id)    = { count = 4 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_256_DGX-H100_Storage" {
  name                     = "AI Cluster 256 DGX-H100 (2048 GPUs) Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 16
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_strg_16_1x400G_1spine_link.id)    = { count = 16 }
    (apstra_rack_type.AI_weka_16_2x200G_1spine_link.id)    = { count = 16 }
  }
}