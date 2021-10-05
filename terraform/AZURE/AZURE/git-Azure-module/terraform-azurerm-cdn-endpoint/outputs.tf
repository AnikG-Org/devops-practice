output "name" {
  description = "The name of the CDN endpoint created"
  value       = azurerm_cdn_endpoint.cdnendpoint.name
}

output "id" {
  description = "The ID of the CDN endpoint created"
  value       = azurerm_cdn_endpoint.cdnendpoint.id
}

