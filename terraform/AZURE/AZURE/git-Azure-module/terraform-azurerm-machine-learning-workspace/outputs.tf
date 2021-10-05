output "id" {
  description = "The ID of the Machine Learning Workspace"
  value       = azurerm_machine_learning_workspace.mlworkspace.id
}

output "name" {
  description = "The Name of the Machine Learning Workspace"
  value       = azurerm_machine_learning_workspace.mlworkspace.name
}
