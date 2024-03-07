resource "apstra_blueprint_iba_probe" "p_device_health" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "device_health"
  probe_config        = jsonencode(
    {
      "max_cpu_utilization" : 80,
      "max_memory_utilization" : 80,
      "max_disk_utilization" : 80,
      "duration" : 660,
      "threshold_duration" : 360,
      "history_duration" : 604800
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_device_health_high_cpu" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Devices With High CPU Utilization"
  probe_id     = apstra_blueprint_iba_probe.p_device_health[count.index].id
  stage        = "Systems with high CPU utilization"
}

resource "apstra_blueprint_iba_widget" "w_device_health_high_memory" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Devices With High Memory Utilization"
  probe_id     = apstra_blueprint_iba_probe.p_device_health[count.index].id
  stage        = "Systems with high memory utilization"
}

resource "apstra_blueprint_iba_probe" "p_ecmp_imbalance" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "fabric_ecmp_imbalance"
  probe_config        = jsonencode(
    {
      "std_max" : 20, "average_period" : 30, "threshold_duration" : 130, "duration" : 300, "max_systems_imbalanced" : 1
    }
  )
}
#, drops, and bandwidth utilization

resource "apstra_blueprint_iba_widget" "w_ecmp_imbalance_fabric" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Fabric ECMP Imbalance"
  probe_id     = apstra_blueprint_iba_probe.p_ecmp_imbalance[count.index].id
  stage        = "live_ecmp_imbalance"
}

resource "apstra_blueprint_iba_probe" "p_device_traffic" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "traffic"
  probe_config        = jsonencode(
    {
      "std_max" : 20, "average_period" : 30, "threshold_duration" : 130, "duration" : 300, "max_systems_imbalanced" : 1
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_device_traffic" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "All Traffic"
  probe_id     = apstra_blueprint_iba_probe.p_device_traffic[count.index].id
  stage        = "Live Interface Counters"
}

resource "apstra_blueprint_iba_probe" "p_hot_cold_interfaces" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "fabric_hotcold_ifcounter"
  probe_config        = jsonencode(
    {
      "if_counter" : "tx_error_pps", "min" : 0, "max" : 10, "max_cold_interface_percentage" : 30,
      "max_hot_interface_percentage" : 30, "average_period" : 60, "threshold_duration" : 10, "duration" : 60
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_hot_cold_interfaces_hot_leaves" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Hot/Cold Interfaces -> Hot Leaves"
  probe_id     = apstra_blueprint_iba_probe.p_hot_cold_interfaces[count.index].id
  stage        = "live_leaf_int_hot"
}

resource "apstra_blueprint_iba_widget" "w_hot_cold_interfaces_cold_leaves" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Hot/Cold Interfaces -> Cold Leaves"
  probe_id     = apstra_blueprint_iba_probe.p_hot_cold_interfaces[count.index].id
  stage        = "live_leaf_int_cold"
}

resource "apstra_blueprint_iba_probe" "p_bandwidth_utilization" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "bandwidth_utilization"
  probe_config        = jsonencode(
    {
      "first_summary_average_period" : 120, "first_summary_total_duration" : 3600,
      "second_summary_average_period" : 3600, "second_summary_total_duration" : 2592000
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_bandwidth_utilization" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Bandwidth Utilization Egress Traffic"
  probe_id     = apstra_blueprint_iba_probe.p_bandwidth_utilization[count.index].id
  stage        = "egress_traffic"
}

resource "apstra_blueprint_iba_probe" "p_east_west_traffic" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "eastwest_traffic"
  probe_config        = jsonencode(
    {
      "label" : "East/West Traffic",
      "average_period" : 60,
      "history_total_duration" : 43200,
      "external_router_tags" : ["obviously_fake_tag"],
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_east_west_traffic" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "East/West Traffic"
  probe_id     = apstra_blueprint_iba_probe.p_east_west_traffic[count.index].id
  stage        = "eastwest_traffic_history"
}

resource "apstra_blueprint_iba_probe" "p_east_west_traffic_gpu_small" {
  blueprint_id        = apstra_datacenter_blueprint.gpu_bp.id
  predefined_probe_id = "eastwest_traffic"
  probe_config        = jsonencode(
    {
      "label" : "East/West Traffic",
      "average_period" : 60,
      "history_total_duration" : 43200,
      "external_router_tags" : ["obviously_fake_tag"],
      "server_tags"          : ["gpu_small"]
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_east_west_traffic_gpu_small" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  name         = "East/West Traffic - Small Racks"
  probe_id     = apstra_blueprint_iba_probe.p_east_west_traffic_gpu_small.id
  stage        = "eastwest_traffic_history"
}

resource "apstra_blueprint_iba_probe" "p_east_west_traffic_gpu_medium" {
  blueprint_id        = apstra_datacenter_blueprint.gpu_bp.id
  predefined_probe_id = "eastwest_traffic"
  probe_config        = jsonencode(
    {
      "label" : "East/West Traffic",
      "average_period" : 60,
      "history_total_duration" : 43200,
      "external_router_tags" : ["obviously_fake_tag"],
      "server_tags"          : ["gpu_medium"]
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_east_west_traffic_gpu_medium" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  name         = "East/West Traffic - Medium Racks"
  probe_id     = apstra_blueprint_iba_probe.p_east_west_traffic_gpu_medium.id
  stage        = "eastwest_traffic_history"
}

resource "apstra_blueprint_iba_probe" "p_east_west_traffic_gpu_a100" {
  blueprint_id        = apstra_datacenter_blueprint.gpu_bp.id
  predefined_probe_id = "eastwest_traffic"
  probe_config        = jsonencode(
    {
      "label" : "East/West Traffic",
      "average_period" : 60,
      "history_total_duration" : 43200,
      "external_router_tags" : ["obviously_fake_tag"],
      "server_tags"          : ["gpu_a100"]
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_east_west_traffic_gpu_a100" {
  blueprint_id        = apstra_datacenter_blueprint.gpu_bp.id
  name         = "East/West Traffic - A100 Servers"
  probe_id     = apstra_blueprint_iba_probe.p_east_west_traffic_gpu_a100.id
  stage        = "eastwest_traffic_history"
}

resource "apstra_blueprint_iba_probe" "p_east_west_traffic_gpu_h100" {
  blueprint_id        = apstra_datacenter_blueprint.gpu_bp.id
  predefined_probe_id = "eastwest_traffic"
  probe_config        = jsonencode(
    {
      "label" : "East/West Traffic",
      "average_period" : 60,
      "history_total_duration" : 43200,
      "external_router_tags" : ["obviously_fake_tag"],
      "server_tags"          : ["gpu_h100"]
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_east_west_traffic_gpu_h100" {
  blueprint_id        = apstra_datacenter_blueprint.gpu_bp.id
  name         = "East/West Traffic - H100 Servers"
  probe_id     = apstra_blueprint_iba_probe.p_east_west_traffic_gpu_h100.id
  stage        = "eastwest_traffic_history"
  description  = "made from terraform"
}

resource "apstra_blueprint_iba_probe" "p_packet_discard_percentage" {
  count               = length(local.blueprints)
  blueprint_id        = local.blueprints[count.index].id
  predefined_probe_id = "packet_discard_percentage"
  probe_config        = jsonencode(
    {
      "history_duration":43200,
      "threshold":1,
      "duration":90,
      "threshold_duration":20
    }
  )
}

resource "apstra_blueprint_iba_widget" "w_packet_discard_percentage" {
  count        = length(local.blueprints)
  blueprint_id = local.blueprints[count.index].id
  name         = "Packet Discard Percentage"
  probe_id     = apstra_blueprint_iba_probe.p_packet_discard_percentage[count.index].id
  stage        = "rx discard percentage"
}

resource "apstra_blueprint_iba_dashboard" "b" {
  count        = length(local.blueprints) - 1
  blueprint_id = local.blueprints[count.index].id
  default      = true
  name         = "Device Health"
  description = "Device Health Dashboard"
  widget_grid  = tolist([
    tolist([
      apstra_blueprint_iba_widget.w_device_health_high_cpu[count.index].id,
      apstra_blueprint_iba_widget.w_device_health_high_memory[count.index].id,
      apstra_blueprint_iba_widget.w_device_traffic[count.index].id,
    ]), tolist([
      apstra_blueprint_iba_widget.w_ecmp_imbalance_fabric[count.index].id,
      apstra_blueprint_iba_widget.w_hot_cold_interfaces_cold_leaves[count.index].id,
      apstra_blueprint_iba_widget.w_hot_cold_interfaces_hot_leaves[count.index].id,
    ]), tolist([
      apstra_blueprint_iba_widget.w_bandwidth_utilization[count.index].id,
      apstra_blueprint_iba_widget.w_east_west_traffic[count.index].id,
      apstra_blueprint_iba_widget.w_packet_discard_percentage[count.index].id,
    ]),
  ])
}

resource "apstra_blueprint_iba_dashboard" "db_gpu" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  default      = true
  name         = "Device Health"
  description = "Device Health Dashboard"
  widget_grid  = tolist([
    tolist([
      apstra_blueprint_iba_widget.w_device_health_high_cpu[2].id,
      apstra_blueprint_iba_widget.w_device_health_high_memory[2].id,
    ]), tolist([
      apstra_blueprint_iba_widget.w_ecmp_imbalance_fabric[2].id,
      apstra_blueprint_iba_widget.w_packet_discard_percentage[2].id,
    ]), tolist([
      apstra_blueprint_iba_widget.w_hot_cold_interfaces_cold_leaves[2].id,
      apstra_blueprint_iba_widget.w_hot_cold_interfaces_hot_leaves[2].id,

    ]),
  ])
}

resource "apstra_blueprint_iba_dashboard" "db_gpu_east_west" {
  blueprint_id = apstra_datacenter_blueprint.gpu_bp.id
  default      = true
  description  = "GPU East West Traffic"
  name         = "GPU East West Traffic"
  widget_grid  = tolist([
    tolist([
      apstra_blueprint_iba_widget.w_east_west_traffic_gpu_a100.id,
      apstra_blueprint_iba_widget.w_east_west_traffic_gpu_h100.id,
    ]), tolist([
      apstra_blueprint_iba_widget.w_east_west_traffic_gpu_small.id,
      apstra_blueprint_iba_widget.w_east_west_traffic_gpu_medium.id,
    ]), tolist([
      apstra_blueprint_iba_widget.w_bandwidth_utilization[2].id,
      apstra_blueprint_iba_widget.w_device_traffic[2].id,
    ]),
  ])
}
