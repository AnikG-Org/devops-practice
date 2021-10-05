output "name" {
  value       = azurerm_data_factory.data_factory.name
  description = "Name of the created data factory"
}

output "id" {
  value       = azurerm_data_factory.data_factory.id
  description = "Id of the created data factory"
}
