terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.46.0" # use version 0.46 or higher
    }
  }
}

provider "apstra" {
  #  url = "https://user:password@apstraurl"
  #  experimental            = true # Needed for any version > 4.2
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}
