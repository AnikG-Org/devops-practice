output "name" {
  description = "The name of the API Management service."
  value       = azurerm_api_management.api_management.name
}

output "id" {
  description = "The ID of the Application Security Group."
  value       = azurerm_api_management.api_management.id
}

output "public_ip_addresses" {
  description = "Public Static Load Balanced IP addresses of the API Management service in the additional location. Available only for Basic, Standard and Premium SKU."
  value = azurerm_api_management.api_management.public_ip_addresses
}

output "private_ip_addresses" {
  description = "Private Static Load Balanced IP addresses of the API Management service."
  value = azurerm_api_management.api_management.private_ip_addresses
}