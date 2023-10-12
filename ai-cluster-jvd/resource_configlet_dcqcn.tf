#
# DCQCN configlet
# 

locals {

  dcqcn_static = <<-EOT
class-of-service {
    classifiers {
        dscp mydscp {
            forwarding-class NO-LOSS {
                loss-priority low code-points [ 000000 000001 000010 000011 000100 000101 000110 000111 ];
            }
        }
    }
    drop-profiles {
        dp1 {
            interpolate {
                fill-level [ 20 60 ];
                drop-probability [ 0 100 ];
            }
        }
    }
    shared-buffer {
        ingress {
            buffer-partition lossless {
                percent 80;
            }
            buffer-partition lossless-headroom {
                percent 10;
            }
            buffer-partition lossy {
                percent 10;
            }
        }
        egress {
            buffer-partition lossless {
                percent 80;
            }
            buffer-partition lossy {
                percent 10;
            }
            inactive: buffer-partition multicast {
                inactive: percent 10;
            }
        }
    }
    forwarding-classes {
        class NO-LOSS queue-num 4 no-loss pfc-priority 0;
    }
    congestion-notification-profile {
        cnp {
            input {
                dscp {
                    code-point 000000 {
                        pfc;
                    }
                    code-point 000001 {
                        pfc;
                    }
                    code-point 000010 {
                        pfc;
                    }
                    code-point 000011 {
                        pfc;
                    }
                    code-point 000100 {
                        pfc;
                    }
                    code-point 000101 {
                        pfc;
                    }
                    code-point 000110 {
                        pfc;
                    }
                    code-point 000111 {
                        pfc;
                    }
                }
            }
        }
    }

    scheduler-maps {
        sm1 {
            forwarding-class NO-LOSS scheduler s1;
        }
    }
    schedulers {
        s1 {
            drop-profile-map loss-priority any protocol any drop-profile dp1;
            explicit-congestion-notification;
        }
    }
EOT


  #  AI Lab Leaf Small DCQN

  ai_lab_leaf_small_dcqcn_interfaces    = <<-EOT
    interfaces {
    # Spine Facing Ports
    %{ for i in range(local.ai_leaf_small_200_spine_port_count) }
      et-0/0/${i} {
        scheduler-map sm1;
      }
    %{ endfor }

    # Server Facing Interfaces 200G
    %{ for i in range(local.ai_leaf_small_200_server_port_count) }
      et-0/0/${local.ai_leaf_small_200_server_dp_port_first+floor(i/4)}:${i%4} {
        congestion-notification-profile cnp;
        scheduler-map sm1;
      }
    %{ endfor }
    # Server Facing Interfaces 400G
    %{ for i in range(local.ai_leaf_small_400_server_port_count) }
      et-0/0/${local.ai_leaf_small_400_server_dp_port_first + i} {
        congestion-notification-profile cnp;
        scheduler-map sm1;
      }
    %{ endfor }
      all {
          unit * {
              classifiers {
                dscp mydscp;
              }
          }
        }
    }
}
EOT
  ai_lab_leaf_small_dcqcn_template_text = "${local.dcqcn_static} \n ${local.ai_lab_leaf_small_dcqcn_interfaces}"

  #  AI Lab Leaf Medium DCQCN

  ai_lab_leaf_medium_dcqcn_interfaces    = <<-EOT
    interfaces {
    # Spine Facing Ports
    %{ for i in range(local.ai_leaf_medium_200_spine_port_count) }
      et-0/0/${i} {
        scheduler-map sm1;
      }
    %{ endfor }

    # Server Facing Interfaces 200G
    %{ for i in range(local.ai_leaf_medium_200_server_port_count) }
      et-0/0/${local.ai_leaf_medium_200_server_dp_port_first+floor(i/4)}:${i%4} {
        congestion-notification-profile cnp;
        scheduler-map sm1;
      }
    %{ endfor }
    # Server Facing Interfaces 400G
    %{ for i in range(local.ai_leaf_medium_400_server_port_count) }
      et-0/0/${local.ai_leaf_medium_400_server_dp_port_first + i} {
        congestion-notification-profile cnp;
        scheduler-map sm1;
      }
    %{ endfor }
      all {
          unit * {
              classifiers {
                dscp mydscp;
              }
          }
        }
    }
}
EOT
  ai_lab_leaf_medium_dcqcn_template_text = "${local.dcqcn_static} \n ${local.ai_lab_leaf_medium_dcqcn_interfaces}"

  ai_leaf_16x400_32x200_dcqcn_interfaces    = <<-EOT
    interfaces {
    # Spine Facing Ports
    %{ for i in range(local.ai_leaf_16x400_32x200_spine_port_count) }
      et-0/0/${i} {
        scheduler-map sm1;
      }
    %{ endfor }

    # Server Facing Interfaces
    %{ for i in range(local.ai_leaf_16x400_32x200_server_port_count) }
      et-0/0/${local.ai_leaf_16x400_32x200_server_dp_port_first+floor(i/2)}:${i%2} {
        congestion-notification-profile cnp;
        scheduler-map sm1;
      }
    %{ endfor }
    all {
          unit * {
              classifiers {
                dscp mydscp;
              }
          }
        }
    }
}
EOT
  ai_leaf_16x400_32x200_dcqcn_template_text = "${local.dcqcn_static} \n ${local.ai_leaf_16x400_64x100_dcqcn_interfaces}"

  ai_leaf_16x400_64x100_dcqcn_interfaces    = <<-EOT
    interfaces {
    # Spine Facing Ports
    %{ for i in range(local.ai_leaf_16x400_64x100_spine_port_count) }
      et-0/0/${i} {
        scheduler-map sm1;
      }
    %{ endfor }

    # Server Facing Interfaces
    %{ for i in range(local.ai_leaf_16x400_64x100_server_port_count) }
      et-0/0/${local.ai_leaf_16x400_64x100_server_dp_port_first+floor(i/2)}:${i%2} {
        congestion-notification-profile cnp;
        scheduler-map sm1;
      }
    %{ endfor }
    all {
          unit * {
              classifiers {
                dscp mydscp;
              }
          }
        }
    }
}
EOT
  ai_leaf_16x400_64x100_dcqcn_template_text = "${local.dcqcn_static} \n ${local.ai_leaf_16x400_64x100_dcqcn_interfaces}"

  ai_spine_32x400_dcqcn_interfaces = <<-EOT
    interfaces {
    # Spine Ports
    %{ for i in range(local.ai_spine_32x400_port_count) }
      et-0/0/${i} {
        scheduler-map sm1;
      }
    %{ endfor }

    all {
          unit * {
              classifiers {
                dscp mydscp;
              }
          }
        }
    }
}
EOT
  ai_spine_32x400_dcqcn_template_text = "${local.dcqcn_static} \n ${local.ai_spine_32x400_dcqcn_interfaces}"

  ai_spine_64x400_dcqcn_interfaces = <<-EOT
    interfaces {
    # Spine Ports
    %{ for i in range(local.ai_spine_64x400_port_count) }
      et-0/0/${i} {
        scheduler-map sm1;
      }
    %{ endfor }

    all {
          unit * {
              classifiers {
                dscp mydscp;
              }
          }
        }
    }
}
EOT
  ai_spine_64x400_dcqcn_template_text = "${local.dcqcn_static} \n ${local.ai_spine_64x400_dcqcn_interfaces}"
}

# Create Catalog Configlet for small lab leaf
resource "apstra_configlet" "ai_lab_leaf_small_dcqcn" {
  name       = "DCQCN for small AI Lab Leaf"
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = local.ai_lab_leaf_small_dcqcn_template_text
    }
    ]
}

# Create Catalog Configlet for medium lab leaf
resource "apstra_configlet" "ai_lab_leaf_medium_dcqcn" {
  name       = "DCQCN for small AI Lab Leaf"
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = local.ai_lab_leaf_medium_dcqcn_template_text
    }
  ]
}


# Create Catalog Configlet for Leaf 16x400/32x200
resource "apstra_configlet" "ai_leaf_16x400_32x200_dcqcn" {
  name       = "DCQCN for AI Leaf 16x400/32x200"
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = local.ai_leaf_16x400_32x200_dcqcn_template_text
    }
  ]
}

# Create Catalog Configlet for Leaf 16x400/64x100
resource "apstra_configlet" "ai_leaf_16x400_64x100_dcqcn" {
  name       = "DCQCN for AI Leaf 16x400/64x100"
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = local.ai_leaf_16x400_64x100_dcqcn_template_text
    }
  ]
}

# Create Catalog Configlet for Spine 32x400
resource "apstra_configlet" "ai_spine_32x400" {
  name       = "DCQCN for AI Spine 32x400"
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = local.ai_spine_32x400_dcqcn_template_text
    }
  ]
}

# Create Catalog Configlet for Spine 64x400
resource "apstra_configlet" "ai_spine_64x400" {
  name       = "DCQCN for AI Spine 64x400"
  generators = [
    {
      config_style  = "junos"
      section       = "top_level_hierarchical"
      template_text = local.ai_spine_64x400_dcqcn_template_text
    }
  ]
}

