output "id" {
  description = "The Cosmos DB SQL Database ID."
  value       = azurerm_cosmosdb_sql_database.cosmosdb_sql_database.id
}

output "name" {
  description = "The Cosmos DB SQL Database name."
  value       = azurerm_cosmosdb_sql_database.cosmosdb_sql_database.name
}
