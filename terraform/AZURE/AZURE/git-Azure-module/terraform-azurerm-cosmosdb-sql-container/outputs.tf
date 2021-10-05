output "id" {
  description = "The Cosmos DB SQL container ID."
  value       = azurerm_cosmosdb_sql_container.cosmosdb_sql_container.id
}

output "name" {
  description = "The Cosmos DB SQL container name."
  value       = azurerm_cosmosdb_sql_container.cosmosdb_sql_container.name
}
