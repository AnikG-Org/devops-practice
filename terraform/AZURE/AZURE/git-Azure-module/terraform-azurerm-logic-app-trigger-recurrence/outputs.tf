output "name" {
  description = "Name of the recurrence trigger created."
  value       = azurerm_logic_app_trigger_recurrence.trigger.name
}

output "id" {
  description = "ID of the recurrence trigger created."
  value       = azurerm_logic_app_trigger_recurrence.trigger.id
}

