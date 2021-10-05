output "name" {
  description = "Name of the IOT consumer group created."
  value       = azurerm_iothub_consumer_group.iothub_consumer_group.name
}

output "id" {
  description = "The ID of the IoTHub Consumer Group."
  value       = azurerm_iothub_consumer_group.iothub_consumer_group.id
}

