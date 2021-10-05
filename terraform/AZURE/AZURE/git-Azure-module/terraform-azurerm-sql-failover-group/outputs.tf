output "name" {
  description = "The name of the failover group."
  value       = azurerm_sql_failover_group.sql_failover_group.name
}

output "id" {
  description = "The id of the failover group."
  value       = azurerm_sql_failover_group.sql_failover_group.id
}