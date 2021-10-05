output "id" {
  description = "server id"
  value       = azurerm_postgresql_server.pssqlserver_01.id
}

output "name" {
  description = "The id of the cluster "
  value       = azurerm_postgresql_server.pssqlserver_01.name
}
