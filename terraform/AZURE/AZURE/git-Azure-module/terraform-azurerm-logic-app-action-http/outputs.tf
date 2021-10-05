output "name" {
  description = "Name of the recurrence trigger created."
  value       = azurerm_logic_app_action_http.action-http.name
}

output "id" {
  description = "ID of the recurrence trigger created."
  value       = azurerm_logic_app_action_http.action-http.id
}
