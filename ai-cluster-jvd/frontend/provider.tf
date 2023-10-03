terraform {
    required_providers {
        apstra = {
            source = "Juniper/apstra"
        }
    }
}

# provider details

provider "apstra" {
    url = "https://admin:Embe1mpls!Embe1mpls!@192.168.122.35:443"
    tls_validation_disabled = true
    blueprint_mutex_enabled = false
    experimental = true
}