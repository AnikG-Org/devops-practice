output "id" {
  description = "The ID of the CosmosDB Account."
  value       = azurerm_cosmosdb_account.db.id
}

output "endpoint" {
  description = "The endpoint used to connect to the CosmosDB account."
  value       = azurerm_cosmosdb_account.db.endpoint
}

output "connection_strings" {
  description = "A list of connection strings available for this CosmosDB account."
  value       = azurerm_cosmosdb_account.db.connection_strings
  sensitive   = true
}