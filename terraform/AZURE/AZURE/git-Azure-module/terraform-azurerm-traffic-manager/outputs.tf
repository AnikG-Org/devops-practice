output "id" {
  description = "ID of the resource group which is created."
  value       = azurerm_traffic_manager_profile.traffic_manager.id
}

output "name" {
  description = "Name of the resource group which is created."
  value       = azurerm_traffic_manager_profile.traffic_manager.name
}

output "fqdn" {
  description = "The FQDN of the created Profile."
  value       = azurerm_traffic_manager_profile.traffic_manager.fqdn
}

