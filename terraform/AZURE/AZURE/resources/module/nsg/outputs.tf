output "id" {
  value       = azurerm_network_security_group.nsg.id
  description = "ID of newly created network security group."
}

output "name" {
  value       = azurerm_network_security_group.nsg.name
  description = "Name of newly created network security group."
}
