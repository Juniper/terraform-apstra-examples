# create fabric resources

resource "apstra_ipv4_pool" "loopback" {
  name = "loopback"
  subnets = [
    { network = "192.0.2.0/24" }
  ]
}

resource "apstra_ipv4_pool" "p2p" {
  name = "p2p"
  subnets = [
    { network = "198.51.100.0/24" }
  ]
}

resource "apstra_asn_pool" "asn_pool" {
  name = "asn_pool"
  ranges = [
    {
      first = 64512
      last  = 64999
    }
  ]
}