terraform {
    required_providers {
        apstra = {
            source = "Juniper/apstra"
        }
    }
}

## provider details

provider "apstra" {
    ## UPDATE WITH YOUR OWN CREDENTIALS
    url = "https://admin:<PASSWORD>@<APSTRA IP ADDRESS>:443"
    tls_validation_disabled = true
    blueprint_mutex_enabled = false
    # experimental = true
}
