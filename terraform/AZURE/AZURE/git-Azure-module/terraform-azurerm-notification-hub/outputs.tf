output "id" {
  description = "The ID of the Stream Analytics Stream Input EventHub."
  value       = azurerm_notification_hub.notification_hub.id
}

output "name" {
  description = "The Name of the Stream Analytics Stream Input EventHub."
  value       = azurerm_notification_hub.notification_hub.name
}

