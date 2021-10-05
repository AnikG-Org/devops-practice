output "id" {
  description = "The ID of the IoTHub."
  value       = azurerm_iothub.iothub.id
}

output "hostname" {
  description = "The hostname of the IotHub Resource."
  value       = azurerm_iothub.iothub.hostname
}

output "event_hub_events_endpoint" {
  description = "The EventHub compatible endpoint for events data."
  value       = azurerm_iothub.iothub.event_hub_events_endpoint
}

output "event_hub_events_path" {
  description = "The EventHub compatible path for events data."
  value       = azurerm_iothub.iothub.event_hub_events_path
}

output "event_hub_operations_endpoint" {
  description = "The EventHub compatible endpoint for operational data."
  value       = azurerm_iothub.iothub.event_hub_operations_endpoint
}

output "event_hub_operations_path" {
  description = "The EventHub compatible path for operational data."
  value       = azurerm_iothub.iothub.event_hub_operations_path
}

output "shared_access_policy" {
  description = "The shared access policies defined within the resource deployment."
  value       = azurerm_iothub.iothub.shared_access_policy
}

