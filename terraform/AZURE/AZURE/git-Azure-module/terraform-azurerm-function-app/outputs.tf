output "id" {
  description = "The ID of the Function App"
  value       = azurerm_function_app.function_app.id
}

output "default_hostname" {
  description = "The default hostname associated with the Function App"
  value       = azurerm_function_app.function_app.default_hostname
}

output "outbound_ip_addresses" {
  description = "List of Outbound IP Address"
  value       = azurerm_function_app.function_app.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "List of Possible Outbound IP Address"
  value       = azurerm_function_app.function_app.possible_outbound_ip_addresses
}

output "identity" {
  description = "Contains the Managed Service Identity information for this App Service."
  value       = azurerm_function_app.function_app.identity
}

output "site_credential" {
  description = "Contains the site-level credentials used to publish to this App Service."
  value       = azurerm_function_app.function_app.site_credential
}

output "kind" {
  description = "The Function App Kind: functionapp, linux, container"
  value       = azurerm_function_app.function_app.kind
}
