## Introduction
Here is an example of the use of the data source [apstra_device_config](https://registry.terraform.io/providers/Juniper/apstra/latest/docs/data-sources/device_config)
## Provider use case
This example uses the [apstra_datacenter_systems](https://registry.terraform.io/providers/Juniper/apstra/latest/docs/data-sources/datacenter_systems) resource
to find the node ID's of the systems in the blueprint.

Once the information is gathered, the example:
- Extracts the Apstra device configs from the data source
- Outputs the system uptime of all the systems.
- Writes the config data for each system to a file for each system in a directory.


We then operate on the files with Git.
- Initiate a git repo
- Add the configs to a commit
- Commit the files to the repo.
