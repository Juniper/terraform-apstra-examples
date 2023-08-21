resource "apstra_ipv4_pool" "spine" {
  name = "terraform spine loopbacks"
  subnets = [
    { network = "10.0.0.0/24" },
  ]
}

resource "apstra_ipv4_pool" "leaf" {
  name = "terraform leaf loopbacks"
  subnets = [
    { network = "10.0.1.0/24" },
  ]
}

resource "apstra_ipv4_pool" "spine_leaf" {
  name = "terraform spine leaf"
  subnets = [
    { network = "10.0.2.0/24" },
  ]
}

resource "apstra_asn_pool" "spine" {
  name = "terraform spine"
  ranges = [
    {
      first = 100
      last  = 199
    }
  ]
}

resource "apstra_asn_pool" "leaf" {
  name = "terraform leaf"
  ranges = [
    {
      first = 200
      last  = 299
    }
  ]
}
