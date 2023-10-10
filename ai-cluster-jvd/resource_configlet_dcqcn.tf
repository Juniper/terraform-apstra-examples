#
# Placeholder file for DCQCN configlet
# 
# todo: needs adaption for interface-based configs

locals {
  configlet = {
    name = "DCQCN"
    generators = [
      {
        config_style  = "junos"
        section       = "top_level_hierarchical"
        template_text = <<-EOT
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
    interfaces {
        et-0/0/1 {
            scheduler-map sm1;
        }
        et-0/0/2 {
            scheduler-map sm1;
        }
        et-0/0/3 {
            congestion-notification-profile cnp;
            scheduler-map sm1;
        }                              
        et-0/0/5 {
            congestion-notification-profile cnp;
            scheduler-map sm1;
        }
        et-0/0/6 {
            congestion-notification-profile cnp;
            scheduler-map sm1;
        }
        et-0/0/7 {
            congestion-notification-profile cnp;
            scheduler-map sm1;
        }
        et-0/0/9 {
            congestion-notification-profile cnp;
            scheduler-map sm1;
        }
        all {
            unit * {
                classifiers {
                    dscp mydscp;
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
}
            EOT
      },
    ]
  }
}
# Create Catalog Configlet
resource "apstra_configlet" "DCQCN" {
  name       = local.configlet.name
  generators = local.configlet.generators
}

