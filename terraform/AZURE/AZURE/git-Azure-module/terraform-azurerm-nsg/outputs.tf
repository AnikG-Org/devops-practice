output "id" {
  value       = length(local.nsg_id) == 1 ? local.nsg_id.id : null
  description = "ID of newly created network security group."
}

output "name" {
  value       = length(local.nsg_name) == 1 ? local.nsg_name.name : null
  description = "Name of newly created network security group."
}

locals {
  nsg_id = {
    for value in azurerm_network_security_group.nsg.*.id :
    "id" => value
  }
  nsg_name = {
    for value in azurerm_network_security_group.nsg.*.name :
    "name" => value
  }
}
