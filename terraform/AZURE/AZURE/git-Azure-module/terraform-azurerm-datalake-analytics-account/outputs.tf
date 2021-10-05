output "id" {
  description = "The ID of the Cognitive Account created."
  value       = azurerm_data_lake_analytics_account.data_lake_analytics_account.id
}

output "name" {
  description = "The name of the Data Lake Analytics account created."
  value       = var.data_lake_analytics_account_name
}

