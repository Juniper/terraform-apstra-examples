

resource "apstra_blueprint_iba_probe" "p_device_health" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  predefined_probe_id = "device_health"
  probe_config = jsonencode(
    {
      "max_cpu_utilization": 80,
      "max_memory_utilization": 80,
      "max_disk_utilization": 80,
      "duration": 660,
      "threshold_duration": 360,
      "history_duration": 604800
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_device_health_high_cpu" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "Devices with high cpu Utilization"
  probe_id = apstra_blueprint_iba_probe.p_device_health[count.index].id
  stage = "Systems with high CPU utilization"
  description = "made from terraform"
}

resource "apstra_blueprint_iba_widget" "w_device_health_high_memory" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "Devices with high memory Utilization"
  probe_id = apstra_blueprint_iba_probe.p_device_health[count.index].id
  stage = "Systems with high memory utilization"
}

resource "apstra_blueprint_iba_probe" "p_ecmp_imbalance" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  predefined_probe_id = "fabric_ecmp_imbalance"
  probe_config        = jsonencode(
    {
      "std_max" : 20,
      "average_period" : 30,
      "threshold_duration" : 130,
      "duration" : 300,
      "max_systems_imbalanced" : 1
    }
  )
}
#, drops, and bandwidth utilization

resource "apstra_blueprint_iba_widget" "w_ecmp_imbalance_fabric" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "ECMP Imbalance (Fabric)"
  probe_id = apstra_blueprint_iba_probe.p_ecmp_imbalance[count.index].id
  stage = "live_ecmp_imbalance"
  description = "made from terraform"
}

resource "apstra_blueprint_iba_probe" "p_device_traffic" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  predefined_probe_id = "traffic"
  probe_config        = jsonencode(
    {
      "std_max" : 20,
      "average_period" : 30,
      "threshold_duration" : 130,
      "duration" : 300,
      "max_systems_imbalanced" : 1
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_device_traffic" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "Device Traffic"
  probe_id = apstra_blueprint_iba_probe.p_device_traffic[count.index].id
  stage = "Live Interface Counters"
  description = "made from terraform"
}

resource "apstra_blueprint_iba_probe" "p_hot_cold_interfaces" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  predefined_probe_id = "fabric_hotcold_ifcounter"
  probe_config        = jsonencode(
    {
      "if_counter": "tx_error_pps",
      "min": 0,
      "max": 10,
      "max_cold_interface_percentage": 30,
      "max_hot_interface_percentage": 30,
      "average_period": 60,
      "threshold_duration": 10,
      "duration": 60
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_hot_cold_interfaces_hot_leaves" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "Hot/Cold Interfaces -> hot leaves"
  probe_id = apstra_blueprint_iba_probe.p_hot_cold_interfaces[count.index].id
  stage = "live_leaf_int_hot"
  description = "made from terraform"
}

resource "apstra_blueprint_iba_widget" "w_hot_cold_interfaces_cold_leaves" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "Hot/Cold Interfaces -> cold leaves"
  probe_id = apstra_blueprint_iba_probe.p_hot_cold_interfaces[count.index].id
  stage = "live_leaf_int_cold"
  description = "made from terraform"
}

resource "apstra_blueprint_iba_probe" "p_bandwidth_utilization" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  predefined_probe_id = "bandwidth_utilization"
  probe_config        = jsonencode(
    {
      "first_summary_average_period": 120,
      "first_summary_total_duration": 3600,
      "second_summary_average_period": 3600,
      "second_summary_total_duration": 2592000
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_bandwidth_utilization" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name = "Bandwidth Utilization Egress Traffic"
  probe_id = apstra_blueprint_iba_probe.p_bandwidth_utilization[count.index].id
  stage = "egress_traffic"
  description = "made from terraform"
}

resource "apstra_blueprint_iba_dashboard" "b" {
  count = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  default = true
  description = "AI Dashboard with TF"
  name = "AI Dashboard with TF"
  widget_grid = tolist([
    tolist([
      apstra_blueprint_iba_widget.w_device_health_high_cpu[count.index].id,
      apstra_blueprint_iba_widget.w_device_health_high_memory[count.index].id,
      apstra_blueprint_iba_widget.w_device_traffic[count.index].id,
    ]),
    tolist([
      apstra_blueprint_iba_widget.w_ecmp_imbalance_fabric[count.index].id,
      apstra_blueprint_iba_widget.w_hot_cold_interfaces_cold_leaves[count.index].id,
      apstra_blueprint_iba_widget.w_hot_cold_interfaces_hot_leaves[count.index].id,
    ]),
    tolist([
      apstra_blueprint_iba_widget.w_bandwidth_utilization[count.index].id,
    ]),
  ])
}

