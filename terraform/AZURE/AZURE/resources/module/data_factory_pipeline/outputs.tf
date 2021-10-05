output "name" {
  value       = azurerm_data_factory_pipeline.pipeline.name
  description = "Name of the created data factory pipeline"
}

output "id" {
  value       = azurerm_data_factory_pipeline.pipeline.id
  description = "Id of the created data factory pipeline"
}

