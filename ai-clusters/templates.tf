resource "apstra_template_rack_based" "AI_Cluster_64_DGX-A100" {
  name                     = "AI Cluster 64 DGX-A100 (512 GPUs)"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 8
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_32xA100.id)    = { count = 2 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_64_DGX-H100" {
  name                     = "AI Cluster 64 DGX-H100 (512 GPUs)"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 8
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_16xH100.id)    = { count = 4 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_128_DGX-A100" {
  name                     = "AI Cluster 128 DGX-A100 (1024 GPUs)"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 16
    logical_device_id = apstra_logical_device.AI-Spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_32xA100.id)    = { count = 4 }
  }
}


resource "apstra_template_rack_based" "AI_Cluster_128_DGX-H100" {
  name                     = "AI Cluster 128 DGX-H100 (1024 GPUs)"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 16
    logical_device_id = apstra_logical_device.AI-Spine_64x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_16xH100.id)    = { count = 8 }
  }
}


resource "apstra_template_rack_based" "AI_Cluster_640_DGX-H100" {
  name                     = "AI Cluster 640 DGX-H100 (5120 GPUs)"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 16
    logical_device_id = apstra_logical_device.AI-Spine_576x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_16xH100.id)    = { count = 40 }
  }
}

resource "apstra_template_rack_based" "AI_Cluster_1152_DGX-A100" {
  name                     = "AI Cluster 1152 DGX-A100 (9216 GPUs)"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 16
    logical_device_id = apstra_logical_device.AI-Spine_288x400.id
  }
  rack_infos = {
    (apstra_rack_type.AI_32xA100.id)    = { count = 36 }
  }
}
