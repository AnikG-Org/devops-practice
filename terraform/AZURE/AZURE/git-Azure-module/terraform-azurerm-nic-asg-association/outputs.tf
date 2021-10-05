output "id" {
  description = "The ID of the association this module creates."
  value       = azurerm_network_interface_application_security_group_association.assocation.*.id
}

