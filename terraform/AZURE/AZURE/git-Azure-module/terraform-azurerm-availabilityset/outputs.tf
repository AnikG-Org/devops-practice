output "id" {
  description = "ID of availability set that is created"
  value       = azurerm_availability_set.avs.id
}

output "name" {
  description = "Name of availability set created"
  value       = azurerm_availability_set.avs.name
}

