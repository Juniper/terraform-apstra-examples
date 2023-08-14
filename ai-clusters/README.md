# Introduction
This set of terraform configs help perform AI training in a data center with an Apstra-managed network fabric deploying logical devices, racks and templates.
The logical devices, racks and templates defined here create the NVIDIA Rail optimized topology outlined [here](https://developer.nvidia.com/blog/doubling-all2all-performance-with-nvidia-collective-communication-library-2-12/)
.
# Prerequisites
* The user needs to have access to an Apstra environment.
  This could be your own Apstra instance or a [cloudlabs](https://cloudlabs.apstra.com/)
  If you would like access to Apstra, please contact your Juniper account team.
* Terraform is already installed in the environment.
  If it is not, please follow the steps [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Deploying the configs into Apstra

## Target the correct Apstra Instance

In the "provider" section of the provider.tf file,  update the URL like so. # URL and credentials can be supplied using 
the "url" parameter in this file.
url = "https://user:password@address_of_apstra"
For instance, if the username is "admin" and the password is "goodguess" and the APSTRA url is https://3.4.5.6:34000 , 
the url field would look like so "https://admin:goodguess@3.4.5.6:34000"
Alternatively, the APSTRA_URL environment variable can be set up similarly.
If Username or Password are not embedded in the URL, the provider will look
for them in the APSTRA_USER and APSTRA_PASS environment variables.
sample provider.tf
```
terraform {
  required_providers {
    apstra = {
      source = "Juniper/apstra"
    }
  }
}

provider "apstra" {
  url = "https://admin:Hello3%23@3.5.8.7:30000/"
  tls_validation_disabled = true
  blueprint_mutex_enabled = false
}
```

If the username or password contains special characters they would need to be URL encoded.
In the example above, the password is 'Hello3#"

### Executing the configs

#### Initialize
From the same directory as the configs, type terraform init. This process downloads the provider from the registry, 
downloads any required modules (we’re not using any), and sets up the backend (we haven’t configured one, so it defaults 
to this folder). 
Type "terraform init" and press enter

Terraform will download the apstra provider and inform you that it is initialized.
```
 % terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of juniper/apstra...
- Installing juniper/apstra v0.27.2...
- Installed juniper/apstra v0.27.2 (self-signed, key ID CB9C922903A66F3F)

Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://www.terraform.io/docs/cli/plugins/signing.html

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```


#### Plan 

As a next step, type "terraform plan" from the same directory as the configs.
Terraform will reach out to the apstra, compute the difference between what is already there and what hte configs ask 
for.
```
% terraform plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # apstra_logical_device.AI-Leaf_16_16x400 will be created
  + resource "apstra_logical_device" "AI-Leaf_16_16x400" {
...
... Trimmed for brevity
...
Plan: 21 to add, 0 to change, 0 to destroy.
```

#### Apply 

type "terraform apply"
This will deploy the logical devices, rack types and the templates into Apstra.
```
% terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
Terraform will perform the following actions:
  # apstra_logical_device.AI-Leaf_16_16x400 will be created
...
... Trimmed for brevity
...
apstra_template_rack_based.AI_Cluster_64_DGX-A100: Creation complete after 3s [id=045520e5-c2b3-4fae-8456-64e66072c9d9]
apstra_template_rack_based.AI_Cluster_128_DGX-A100: Creation complete after 3s [id=d8f200b9-633b-427c-8b11-5ff5a9b7f33c]

Apply complete! Resources: 21 added, 0 changed, 0 destroyed.
```

## Login and Check in Apstra

### Sample Template
<img width="1410" alt="image" src="https://github.com/rajagopalans/apstra-tf-ai/assets/2322011/853f6eda-61c5-4298-ae1d-220d66d5a20a">

### Sample Rack Type
<img width="1417" alt="image" src="https://github.com/rajagopalans/apstra-tf-ai/assets/2322011/a96c615f-71d9-42f8-bc50-2bd530a38edd">

### Sample Logical Device
<img width="1417" alt="image" src="https://github.com/rajagopalans/apstra-tf-ai/assets/2322011/d7e28652-d03b-4dbd-9aec-81cb9227bd4f">

