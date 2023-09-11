# Introduction
Building on the AI cluster designs [here](https://github.com/Juniper/terraform-apstra-examples/tree/master/ai-cluster-designs) with rail-optimized GPU fabrics of various sizes, this terraform config for Apstra will build a specific set of 3 blueprints for a small reference AI cluster's dedicated backend GPU fabric, a dedicated storage fabric, and a frontend management fabric. This example shall serve as a Juniper validated design (JVD) set of configurations that can be applied to larger clusters. It has two NVIDIA rail-optimzed groups with Juniper QFX5220 leaf switches and high-radix PTX10008 spines, with examples here for A100s and H100-based servers.

# Usage

Please follow the steps in the README in the root directory to setup the provider.tf file.
