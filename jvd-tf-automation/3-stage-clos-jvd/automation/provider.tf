terraform {
    required_providers {
        apstra = {
            source = "Juniper/apstra"
        }
    }
}

## provider details

provider "apstra" {
    url = "https://admin:Juniper!123@192.168.122.253:443"
    tls_validation_disabled = true
    blueprint_mutex_enabled = false
    # experimental = true
}
