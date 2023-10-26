
#
# TEMPLATES
# (for fabrics: GPU compute, storage, frontend mgmt)
#

# Large fabrics should use PTX high-radix modular chassic spines
# Here we use PTX10008 (288x400G)
# Smaller could be fewer line card per chassis (room to grow) or PTX10004
# Larger could be PTX10016 or (future) 800G line cards
# Adjust racks as needed for scale. This example is with one stripe of 5220s and one of 5230s

resource "apstra_template_rack_based" "ai_cluster_gpus_large" {
  name                     = "AI Cluster GPU Fabric - Large"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_72x400.id
  }
  rack_infos = {
    (apstra_rack_type.gpu_backend_sml.id) = { count = 1 }
    (apstra_rack_type.gpu_backend_med.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_72x400,
      apstra_rack_type.gpu_backend_sml,
      apstra_rack_type.gpu_backend_med,
    ]
  }
}

# Small-Medium fabrics can optionally use QFX spines
# Here we will use 5230 (64x400G)
# Smaller would be 5220 (32x400G), and (future) larger 5240 (64x800G)
# Adjust racks as needed for scale. This example is with one stripe of 5220s and one of 5230s

resource "apstra_template_rack_based" "ai_cluster_gpus_medium" {
  name                     = "AI Cluster GPU Fabric - Medium"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_64x400.id
  }
  rack_infos = {
    (apstra_rack_type.gpu_backend_sml.id) = { count = 1 }
    (apstra_rack_type.gpu_backend_med.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_64x400,
      apstra_rack_type.gpu_backend_sml,
      apstra_rack_type.gpu_backend_med,
    ]
  }
}

resource "apstra_template_rack_based" "ai_cluster_storage" {
  name                     = "AI Cluster Storage Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.storage_ai.id)   = { count = 1 }
    (apstra_rack_type.storage_weka.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_32x400,
      apstra_rack_type.storage_ai,
      apstra_rack_type.storage_weka,
    ]
  }
}

resource "apstra_template_rack_based" "ai_cluster_mgmt" {
  name                     = "AI Cluster Management Fabric"
  asn_allocation_scheme    = "unique"
  overlay_control_protocol = "static"
  spine = {
    count             = 2
    logical_device_id = apstra_logical_device.ai_spine_32x400.id
  }
  rack_infos = {
    (apstra_rack_type.frontend_mgmt_ai.id)   = { count = 1 }
    (apstra_rack_type.frontend_mgmt_weka.id) = { count = 1 }
  }
  lifecycle {
    replace_triggered_by = [
      apstra_logical_device.ai_spine_32x400,
      apstra_rack_type.frontend_mgmt_ai,
      apstra_rack_type.frontend_mgmt_weka,
    ]
  }
}

