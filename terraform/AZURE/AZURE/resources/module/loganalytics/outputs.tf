 output "name" {
   value       = azurerm_log_analytics_workspace.loganalytics.name
   description = "name of the log analytics workspace created."
 }

 output "id" {
   value       = azurerm_log_analytics_workspace.loganalytics.id
   description = "ID of the log analytics workspace created."
 }

output "workspace_id" {
  value       = azurerm_log_analytics_workspace.loganalytics.workspace_id #id
  description = "The Workspace (or Customer) ID for the Log Analytics Workspace."
}