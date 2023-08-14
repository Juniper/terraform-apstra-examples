## Introduction
This is intended as a repository of sample terraform configs for Apstra.
Each directory in this project tracks a different project that uses the terraform provider for Apstra.

## Prerequisites
* The user needs to have access to an Apstra environment.
  This could be your own Apstra instance or a [cloudlabs](https://cloudlabs.apstra.com/)
  If you would like access to Apstra, please contact your Juniper account team.
* Terraform is already installed in the environment.
  If it is not, please follow the steps [here](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

## Projects
### ai-clusters 
   This set of terraform configs help perform AI training in a data center with an Apstra-managed network fabric deploying logical devices, racks and templates.
