# Server LDs

# Lambda Labs Hyperplane8-A100
#
# Standard networking: 1x NVIDIA ConnectX-6 Dx adapter card, 100GbE, dual-port QSFP28, AIOM PCIe 4.0 x16
# Storage Networking: 1x 200 GbE NVIDIA ConnectX-6 VPI NIC: Dual-port QSFP56
# GPUDirect RDMA Networking: 8x NVIDIA ConnectX-7 Adapter Card 200GbE Single-port QSFP PCIe 4.0 x16

resource "apstra_logical_device" "a100_mgmt_1x100g" {
  name = "A100 Server Mgmt 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "a100_storage_1x200g" {
  name = "A100 Server Storage 1x200G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "200G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "a100_gpu_8x200g" {
  name = "A100 Server GPU 8x200G"
  panels = [
    {
      rows    = 2
      columns = 4
      port_groups = [
        {
          port_count = 8
          port_speed = "200G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

# NVIDIA DGX H100
#
# Standard networking: 1x 100 Gb/s Ethernet
# Storage Networking: 2x QSPF112 400 Gb/s InfiniBand/Ethernet,
# GPUDirect RDMA Networking: 4x OSFP ports serving 8x single-port NVIDIA ConnectX-7 VPI 400 Gb/s InfiniBand/Ethernet

resource "apstra_logical_device" "h100_mgmt_1x100g" {
  name = "H100 Server Mgmt 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "h100_storage_2x400g" {
  name = "H100 Server Storage 2x400G"
  panels = [
    {
      rows    = 1
      columns = 2
      port_groups = [
        {
          port_count = 2
          port_speed = "400G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "h100-gpu_8x400g" {
  name = "H100 Server GPU 8x200G"
  panels = [
    {
      rows    = 2
      columns = 4
      port_groups = [
        {
          port_count = 8
          port_speed = "400G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}


# Weka Server Storage Nodes
#
# Standard networking: 1x NVIDIA ConnectX-6 Dx adapter card, 100GbE, dual-port QSFP28, PCIe 4.0 x16
# Storage Networking: 2x NVIDIA ConnectX-6 VPI adapter card, 200GbE, dual-port QSFP56, OCP 3.0

resource "apstra_logical_device" "weka_mgmt_1x100g" {
  name = "Weka Server Mgmt 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "weka_storage_2x200g" {
  name = "Weka Server Storage 2x200G"
  panels = [
    {
      rows    = 1
      columns = 2
      port_groups = [
        {
          port_count = 2
          port_speed = "200G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}

resource "apstra_logical_device" "headend_device_1x100g" {
  name = "Headend Server 1x100G"
  panels = [
    {
      rows    = 1
      columns = 1
      port_groups = [
        {
          port_count = 1
          port_speed = "100G"
          port_roles = ["leaf", "access"]
        },
      ]
    }
  ]
}
