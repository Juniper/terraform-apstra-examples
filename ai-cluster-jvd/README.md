# Introduction
Building on the AI cluster designs [here](https://github.com/Juniper/terraform-apstra-examples/tree/master/ai-cluster-designs) with rail-optimized GPU fabrics of various sizes, this terraform config for Apstra will build a specific set of 3 blueprints for a reference AI cluster's dedicated backend GPU fabric, a dedicated storage fabric, and a frontend management fabric. This example shall serve as a Juniper validated design (JVD) set of configurations that can be applied to larger clusters. It has two NVIDIA rail-optimzed groups with Juniper QFX5220 leaf switches in one stripe of 8, and QFX5230 leaf switches in another stripe of 8. It has options for both QFX5230 spines or high-radix PTX10008 spines, with examples here for A100s and H100-based servers in uniform racks, or as deployed in the "LabLeaf" rack with mixed server access for half A100 and half H100 connectivity to serve as an example, and because that is what is used in the real lab test environment for this configuration.

# Usage

Please follow the steps in the README in the root directory to setup the provider.tf file.

ATTN: Until Apstra 4.2.1 is released, before applying with Terraform, you must import the device profile for QFX5230 using juniper_qfx5230_64cd_junos.json
