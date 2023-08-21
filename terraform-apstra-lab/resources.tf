## Create an IPv4 resource pool according to the instructions in the lab guide.
resource "apstra_ipv4_pool" "lab_guide" {
  name = "apstra-pool"
  subnets = [
    { network = "4.0.0.0/24" },
    { network = "4.0.1.0/24" },
    { network = "5.0.0.0/20" }
  ]
}

# Create an ASN resource pool according to the instructions in the lab guide.
resource "apstra_asn_pool" "lab_guide" {
  name = "vpod-evpn-asn-pool"
  ranges = [
    {
      first = 100
      last  = 1000
    }
  ]
}
