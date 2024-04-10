terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.56.0" # use version 0.53.1 or higher
    }
  }
}

provider "apstra" {
  #  url = "https://user:password@apstraurl"
  experimental            = true # Needed for any version > 4.2.1
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
  }
