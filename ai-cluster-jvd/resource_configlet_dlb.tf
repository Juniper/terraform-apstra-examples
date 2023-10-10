#
# In AI clusters' backend RoCE fabrics with low entroy of flows that are long lived,
# regular ECMP will result in flow hashing collisions that distribute flow traffic in a
# manner causing ECMP imbalances leading to congestion, even in such fabrics without
# oversubscription and possible undersubscription. While Apstra IBA probes can detect
# and report this, Junos DLB/ALB can avoid this by using flowlet mode or 
# per-packet round-robin mode to distribute traffic across links more evenly,
# thus avoiding congestion as best possible. Note that per-packet load balancing can cause
# out of order receiving, and only some NICs may be able to mitigate the drastic
# performance loss caused by of out of order packets by reordering them in hardware.
#
# Junos Dynamic load balancing (aka Adaptive load balancing in PTX Series) will be applied
# to QFX leaf switches here with an Apstra configlet. In smaller fabrics that may use 
# QFX spines with multiple leaf-spine pairwise links, it's also useful to add DLB there.
#
# Note in the DLB mode here for the JVD, we use flowlet which is conservative, not assuming
# NICs that can (or are configured to) reorder in hardwre, but if per-packet is possible,
# it results in perfectly balanced ECMP on the next-hop links. See Junos documentation for detail
#
# the Junos operational command "show forwarding-options enhanced-hash-key" will show the current
# DLB mode and potential flowlet inactivity timeout interval.
#
# The config for DLB generally is as follows: 
#
# forwarding-options {
#   enhanced-hash-key {
#     ecmp-dlb {
#       flowlet { << can also be per-packet or assigned-flow (for debugging)
#         inactivity-interval 16;
#       }
#       ether-type {
#         ipv4;
#       }
#     }
#   }
#   hash-key {
#     family inet {
#       layer-3;
#       layer-4;
#     }
#   }
# }
# policy-options {
#   policy-statement PPLB {
#   then {
#           load-balance per-packet;
#       }

#   }
# }
# routing-options {
#   forwarding-table {
#     export PPLB;
#   }
# }
#
# Note the last two stanzas are added in the Apstra reference design by default,
# so we don't need them in the Apstra configlet. And note the policy-options config
# for load-balance per-packet has nothing to do with the DLB mode of per-packet.
# It must be left as is for flowlet DLB mode as well

locals {
  cfg_data = {
    name = "DLB"
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
            EOT
      },
    ]
  }
}
# Create Catalog Configlet
resource "apstra_configlet" "dlb" {
  name       = local.cfg_data.name
  generators = local.cfg_data.generators
}

