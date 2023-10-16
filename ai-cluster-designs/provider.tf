terraform {
  required_providers {
    apstra = {
      source = "Juniper/apstra"
    }
  }
}

provider "apstra" {
  url = "https://user:password@apstraurl"
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
  experimental            = true # needed to work with Apstra 4.2 until provider is updated
}
