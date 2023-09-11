# Introduction
This set of terraform configs help setup data center fabrics for an AI cluster. AI training requires a dedicated backend GPU fabric, a dedicated storage fabric, and a frontend management fabric. Here we show such Apstra-managed network fabrics deploying logical devices, racks and templates for DGX (or HGX equivalent) servers based on A100 and H100 GPUs having 200GE and 400GE access connectivity respectively.
The logical devices, racks and templates defined here create the NVIDIA Rail-optimized topology outlined [here](https://developer.nvidia.com/blog/doubling-all2all-performance-with-nvidia-collective-communication-library-2-12/)
.
# Usage

Please follow the steps in the README in the root directory.

# Confirm in Apstra

### Sample Template
<img width="1625" src="https://github.com/Juniper/terraform-apstra-examples/assets/2322011/f182a389-3ad9-4319-b05e-74d1479b3733">

### Sample Rack Type
<img width="1609" src="https://github.com/Juniper/terraform-apstra-examples/assets/2322011/3727614a-b196-4ce0-9d48-44a9d1770ac4">

### Sample Logical Device
<img width="1616" src="https://github.com/Juniper/terraform-apstra-examples/assets/2322011/ce563799-0c7d-4a99-8669-d5dcf0b4c77c">

### All Templates Examples
<img width="984" src="https://github.com/Juniper/terraform-apstra-examples/assets/5421664/b015f748-e126-4d90-931e-741122c9eefb">
