terraform {
  required_providers {
    apstra = {
      source  = "Juniper/apstra"
      version = "0.27.2"
    }
  }
}

provider "apstra" {
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
  api_timeout             = 0
}
