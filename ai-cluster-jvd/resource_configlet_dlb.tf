locals {
  cfg_data = {
    name = "DLB for AI leaves"
    generators = [
      {
        config_style  = "junos"
        section       = "top_level_hierarchical"
        template_text = <<-EOT
            forwarding-options {
              enhanced-hash-key {
                ecmp-dlb {
                  flowlet {
                    inactivity-interval 16;
                  }
                  ether-type {
                    ipv4;
                  }
                }
              }
              hash-key {
                family inet {
                  layer-3;
                  layer-4;
                }
              }
            }
            policy-options {
              policy-statement PPLB {
              then {
                      load-balance per-packet;
                  }

              }
            }
            routing-options {
              forwarding-table {
                export PPLB;
              }
            }
            EOT
      },
    ]
  }
}
# Create Catalog Configlet
resource "apstra_configlet" "DLBForLeaf" {
  name       = local.cfg_data.name
  generators = local.cfg_data.generators
}

