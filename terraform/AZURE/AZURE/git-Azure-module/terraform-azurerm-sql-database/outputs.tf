output "id" {
  description = "The SQL Database ID created"
  value       = azurerm_sql_database.db.id
}

output "creation_date" {
  description = "The Creation date of the SQL Database"
  value       = azurerm_sql_database.db.creation_date
}

output "default_secondary_location" {
  description = "The default secondary location of the SQL Database"
  value       = azurerm_sql_database.db.default_secondary_location
}