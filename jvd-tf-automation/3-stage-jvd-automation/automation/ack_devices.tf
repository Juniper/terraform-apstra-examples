# ## returns IDs of all agents within a specific CIDR

# data "apstra_agents" "agent_ids" {
#   depends_on = [ apstra_managed_device.device ]
#   filter = {
#     management_ip    = "192.168.122.0/24"
#     off_box          = true
#   }
# }

# ## gather details of every individual agent ID

# data "apstra_agent" "agent" {
#   for_each = data.apstra_agents.agent_ids.ids
#   agent_id = each.key 
# }

# # ack each agent with the derived SN (passed into device_key) 

# resource "apstra_managed_device_ack" "device" {
#   for_each = data.apstra_agent.agent
#   agent_id = each.key
#   device_key = each.value.device_key
# }


### chris' new code

## returns IDs of all agents within a specific CIDR

#data "apstra_agents" "agent_ids" {
#  for_each = local.devices
#  depends_on = [ apstra_managed_device.device ]
##  filter = {
##    management_ip    = each.value.management_ip
##    off_box          = true
##  }
#}

## gather details of every individual agent ID

data "apstra_agent" "agent" {
  for_each = apstra_managed_device.device
  agent_id = each.value.agent_id
}

# ack each agent with the derived SN (passed into device_key)

resource "apstra_managed_device_ack" "device" {
  for_each = data.apstra_agent.agent
  agent_id = each.value.agent_id
  device_key = each.value.device_key
}
