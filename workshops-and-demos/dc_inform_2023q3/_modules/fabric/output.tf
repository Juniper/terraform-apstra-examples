output "blueprint_id" { value = apstra_datacenter_blueprint.dc_1.id }

output "staging_revision" { value = data.apstra_blueprint_deployment.dc_1.revision_staged }

output "routing_zone_id" { value = data.apstra_datacenter_routing_zone.default.id }
