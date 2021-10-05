output "id" {
  description = "The SQL Server ID"
  value       = azurerm_sql_server.sql_server.id
}

output "name" {
  description = "The name of the sql server"
  value       = azurerm_sql_server.sql_server.name
}

output "fqdn" {
  description = "The fully qualified domain name of the Azure SQL Server (e.g. myServerName.database.windows.net)"
  value       = azurerm_sql_server.sql_server.fully_qualified_domain_name
}

output "identity" {
  description = "The SQL Server identity"
  value       = azurerm_sql_server.sql_server.identity
}

output "db_ids" {
  description = "The SQL dabase IDs"
  value       = azurerm_sql_database.databases.*.id
}
