output "id" {
  description = "The ID of newly created workspace"
  value       = azurerm_databricks_workspace.databricks_workspace.id
}

output "managed_resource_group_id" {
  description = "The assigned id of the resource group id where the resource is to be placed."
  value       = azurerm_databricks_workspace.databricks_workspace.managed_resource_group_id
}
