output "id" {
  description = "server id"
  value       = azurerm_sql_server.sqlserver.id
}

output "name" {
  description = "The id of the cluster "
  value       = azurerm_sql_server.sqlserver.name
}
