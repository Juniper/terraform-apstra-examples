terraform {
    required_providers {
        apstra = {
            source = "Juniper/apstra"
        }
    }
}

## provider details

provider "apstra" {
    url = "https://<APSTRA USERNAME>:<APSTRA PASSWORD>@<APSTRA INSTANCE IP>:443"
    tls_validation_disabled = true
    blueprint_mutex_enabled = false
    # experimental = true
}
