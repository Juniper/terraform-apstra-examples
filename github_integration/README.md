
# Introduction

The Terraform provider for Apstra [available here](https://registry.terraform.io/providers/Juniper/apstra/latest), enables terraform users to automate Apstra.

Integrating Terraform Cloud and Github allows users to incorporate CI/CD concepts into their network provisioning workflow, enabling a more cloud-like experience to managing their datacenter.

![newgitapstra-GitTFAPstra drawio](https://github.com/Juniper-SE/git-apstra-done/assets/2322011/fa4c5126-2d14-4369-a46c-65660c23e2dc)


This repo provides sample code that can be used to automate Apstra via github and terraform

## Bringing Continuous Integration, Testing and Deployment to Networking

Apstra's intent-based networking permits network admins to bring the cloud-like experience to Datacenter Administration.
The terraform provider for Apstra permits the Infrastructure as Code approach.
Integrating git with a terraform cloud instance that talks to Apstra permits the users to have an automated deployment process, very similar to how software gets tested and deployed today.

This repo provides the sample code to get started on this process.

# Setup
## Apstra Instance

For this an internet-accessible Apstra will be needed. This could be via Apstra Cloud Labs (https://cloudlabs.apstra.com/) or your own Apstra installation. If you would like access to Apstra for this lab please contact your Juniper account team.

## Setting up Terraform Cloud

Login to Terraform Cloud. If you have a Github account, that can be used to login to Terraform Cloud as well.

## Create New Organization

If your Terraform Cloud Instance does not already have an organization, create one

<img width="1810" alt="CreateOrg" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/490049b5-8721-4874-ba7f-0073b581019a">


## Create a Terraform Cloud Workspace. Choose API driven Workflow
<img width="1615" alt="APIDrivenWorkflow" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/cc03661c-de5f-41fa-b456-85a6e5962c88">

Note the Organization and Workspace names, they will be needed later

<img width="1791" alt="TerraformOrg" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/a0f18ed2-c69b-40af-9c78-a77e4b2231a3">

### Create Environment Variables for the Apstra URL, Username and Password (APSTRA_URL, APSTRA_USER and APSTRA_PASS)
<img width="2995" alt="SetupEnvVarsInTFCloud" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/4755e594-0925-4a2b-9564-11ac56f1f9dc">
This step is for downstream connections from Terraform To Apstra

### Generate a TF Token
This step will permit Github to execute actions in Terraform Cloud as the user

Navigate to User Settings -> Tokens

<img width="2119" alt="CreateTFToken" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/fee5d73c-1013-495c-b3da-4168389acf9b">

Generate the API token

<img width="2185" alt="GenerateTFToken" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/0c717d11-9c65-4f94-916b-ea10f3ca72bd">

Note the API token.

## Setting up Github

### Create An Empty Repo

<img width="1561" alt="Create Empty Repo" src="https://github.com/Juniper/terraform-apstra-examples/assets/2322011/4ccdbcc4-cd8e-434b-838c-4ed4d127942f">

The repo can be private or public

### Update the repo with code
```

 projects % mkdir tmp
 projects % cd tmp 
 tmp % git clone git@github.com:Juniper/terraform-apstra-examples
Cloning into 'terraform-apstra-examples'...
remote: Enumerating objects: 139, done.
remote: Counting objects: 100% (139/139), done.
remote: Compressing objects: 100% (116/116), done.
remote: Total 139 (delta 55), reused 81 (delta 21), pack-reused 0
Receiving objects: 100% (139/139), 4.04 MiB | 2.78 MiB/s, done.
Resolving deltas: 100% (55/55), done.
 tmp % git clone git@github.com:rajagopalans/git-apstra-demo     
Cloning into 'git-apstra-demo'...
warning: You appear to have cloned an empty repository.
 tmp % cd git-apstra-demo 
 git-apstra-demo % cp -R ../terraform-apstra-examples/github_integration/* ./
 git-apstra-demo % cp -R ../terraform-apstra-examples/github_integration/.github ./ 
 git-apstra-demo % ls
README.md	provider.tf	simple.tf
 git-apstra-demo % ls -al
total 32
drwxr-xr-x   7 rsubrahmania  staff   224 Sep  5 10:31 .
drwxr-xr-x   4 rsubrahmania  staff   128 Sep  5 10:29 ..
drwxr-xr-x  10 rsubrahmania  staff   320 Sep  5 10:28 .git
drwxr-xr-x   3 rsubrahmania  staff    96 Sep  5 10:31 .github
-rw-r--r--   1 rsubrahmania  staff  5726 Sep  5 10:31 README.md
-rw-r--r--   1 rsubrahmania  staff   226 Sep  5 10:31 provider.tf
-rw-r--r--   1 rsubrahmania  staff   968 Sep  5 10:31 simple.tf
 git-apstra-demo % git commit -am "add the code to do the github integration"
On branch master

Initial commit

Untracked files:
	.github/
	README.md
	provider.tf
	simple.tf

nothing added to commit but untracked files present
 git-apstra-demo % git add *
 git-apstra-demo % git commit -am "add the code to do the github integration"
[master (root-commit) 2f540a7] add the code to do the github integration
 3 files changed, 185 insertions(+)
 create mode 100644 README.md
 create mode 100644 provider.tf
 create mode 100644 simple.tf
 git-apstra-demo % git add .github 
 git-apstra-demo % git commit -am "add the .github folder"                   
[master 16d6fb8] add the .github folder
 2 files changed, 124 insertions(+)
 create mode 100644 .github/workflows/terraform-apply.yml
 create mode 100644 .github/workflows/terraform-plan.yml
 git-apstra-demo % git push
Counting objects: 11, done.
Delta compression using up to 12 threads.
Compressing objects: 100% (10/10), done.
Writing objects: 100% (11/11), 4.85 KiB | 1.62 MiB/s, done.
Total 11 (delta 1), reused 0 (delta 0)
remote: Resolving deltas: 100% (1/1), done.
To github.com:rajagopalans/git-apstra-demo
 * [new branch]      master -> master
 git-apstra-demo %
```
### Confirm that the code got committed into the repo
<img width="1788" alt="Code is in the repo." src="https://github.com/Juniper/terraform-apstra-examples/assets/2322011/96a8761c-b477-4012-9c01-b38c036e3540">

### Set up the variables for the github Repo

#### Set up the TF_API_TOKEN
<img width="1653" alt="SetupTFAPISecret" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/bc2c9544-1fec-471a-9fda-204584016241">

#### Set up TF_CLOUD_ORGANIZATION and TF_WORKSPACE
These map to the organization and workspace in Terraform Cloud that were set up
<img width="1713" alt="SetupEnvVars" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/29266c80-feb3-4d2d-80af-51b332c6c403">

# Run Terraform from Github to make a change

## Make a Branch, Make a Change
<img width="812" alt="makebranch" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/6cbccb75-49c4-4d6b-a2b1-c8f2e3c303e0">

We will make a simple change (change the name of the Property Set)
<img width="1224" alt="gitdiff" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/b43ec56c-3c4d-4a47-a5ed-046466159487">

Let us push the change into the repo

<img width="961" alt="makebarnch2" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/8bd98692-61fb-42fa-9121-2db89bf90916">

## Create PR

When a PR is made, note that the terraform plan is being run
<img width="1278" alt="WhenPRIsMade" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/236cd015-928a-4b6a-a4b2-01c2b99b981f">

After the terraform plan is run, the comment is updated with the proposed change.

<img width="1303" alt="TerraformPlan" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/34cb5a84-f2e0-4e8a-8684-118d0070452d">

## Merge the PR

### Terraform Apply Runs on merge

When the PR is merged the Actions Terraform Apply starts running

Running

<img width="1749" alt="TerraformApplyOnMerge" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/deee485a-9958-4976-a922-1d3071ee1060">

Complete

<img width="1732" alt="RunOnGithub" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/49130b57-53e5-4a1e-be37-df46fd27c2f2">

### Run on Terraform Cloud


<img width="1716" alt="TerraformCloudApply" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/6eb7806d-2272-40b3-8c35-7c61124fc31f">


# Change Made into Apstra

<img width="1096" alt="ChangeInApstra" src="https://github.com/Juniper-SE/git-apstra-done/assets/2322011/75081cd1-f776-455c-ab51-374aa97d3f0a">




