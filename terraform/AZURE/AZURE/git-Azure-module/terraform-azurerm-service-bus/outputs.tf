output "id" {
  description = "Service bus namespace ID."
  value       = azurerm_servicebus_namespace.servicebus.id
}

output "name" {
  description = "Service bus namespace."
  value       = var.name
}

output "default_primary_connection_string" {
  description = "The primary connection string for the authorization rule RootManageSharedAccessKey."
  value       = azurerm_servicebus_namespace.servicebus.default_primary_connection_string
}

output "default_primary_key" {
  description = "The primary access key for the authorization rule RootManageSharedAccessKey."
  value       = azurerm_servicebus_namespace.servicebus.default_primary_key
}

output "default_secondary_connection_string" {
  description = "The secondary connection string for the authorization rule RootManageSharedAccessKey."
  value       = azurerm_servicebus_namespace.servicebus.default_secondary_connection_string
}

output "default_secondary_key" {
  description = "The secondary access key for the authorization rule RootManageSharedAccessKey."
  value       = azurerm_servicebus_namespace.servicebus.default_secondary_key
}
