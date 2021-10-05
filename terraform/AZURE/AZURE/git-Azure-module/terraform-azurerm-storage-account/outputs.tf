###  Output variables  ###

output "name" {
  description = "Name of storage account that is created"
  value       = azurerm_storage_account.storage.name
}

output "id" {
  description = "ID of storage account that is created"
  value       = azurerm_storage_account.storage.id
}

output "network_rules_id" {
  description = "ID of storage account network rules created"
  value       = azurerm_storage_account_network_rules.network_rules.id
}

output "primary_access_key" {
  description = "Primary access key of storage account that is created"
  value       = azurerm_storage_account.storage.primary_access_key
}

output "secondary_access_key" {
  description = "Secondary access key of storage account that is created"
  value       = azurerm_storage_account.storage.secondary_access_key
}

output "primary_blob_endpoint" {
  description = "Primary blob endpoint of storage account that is created"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "primary_connection_string" {
  description = "Primary Connection String of storage account that is created"
  value       = azurerm_storage_account.storage.primary_connection_string
}

output "primary_web_host" {
  description = "The hostname with port if applicable for web storage in the primary location."
  value       = azurerm_storage_account.storage.primary_web_host
}

output "storage_accounts_all" {
  value = [
    {
      id : azurerm_storage_account.storage.id
      primary_location : azurerm_storage_account.storage.primary_location
      primary_blob_endpoint : azurerm_storage_account.storage.primary_blob_endpoint
      primary_blob_host : azurerm_storage_account.storage.primary_blob_host
      secondary_blob_endpoint : azurerm_storage_account.storage.secondary_blob_endpoint
      secondary_blob_host : azurerm_storage_account.storage.secondary_blob_host
      primary_queue_endpoint : azurerm_storage_account.storage.primary_queue_endpoint
      primary_queue_host : azurerm_storage_account.storage.primary_queue_host
      secondary_queue_endpoint : azurerm_storage_account.storage.secondary_queue_endpoint
      secondary_queue_host : azurerm_storage_account.storage.secondary_queue_host
      primary_table_endpoint : azurerm_storage_account.storage.primary_table_endpoint
      primary_table_host : azurerm_storage_account.storage.primary_table_host
      secondary_table_endpoint : azurerm_storage_account.storage.secondary_table_endpoint
      secondary_table_host : azurerm_storage_account.storage.secondary_table_host
      primary_file_endpoint : azurerm_storage_account.storage.primary_file_endpoint
      primary_file_host : azurerm_storage_account.storage.primary_file_host
      secondary_file_endpoint : azurerm_storage_account.storage.secondary_file_endpoint
      secondary_file_host : azurerm_storage_account.storage.secondary_file_host
      primary_dfs_endpoint : azurerm_storage_account.storage.primary_dfs_endpoint
      primary_dfs_host : azurerm_storage_account.storage.primary_dfs_host
      secondary_dfs_endpoint : azurerm_storage_account.storage.secondary_dfs_endpoint
      secondary_dfs_host : azurerm_storage_account.storage.secondary_dfs_host
      primary_web_endpoint : azurerm_storage_account.storage.primary_web_endpoint
      primary_web_host : azurerm_storage_account.storage.primary_web_host
      secondary_web_endpoint : azurerm_storage_account.storage.secondary_web_endpoint
      secondary_web_host : azurerm_storage_account.storage.secondary_web_host
      primary_access_key : azurerm_storage_account.storage.primary_access_key
      secondary_access_key : azurerm_storage_account.storage.secondary_access_key
      primary_connection_string : azurerm_storage_account.storage.primary_connection_string
      secondary_connection_string : azurerm_storage_account.storage.secondary_connection_string
      primary_blob_connection_string : azurerm_storage_account.storage.primary_blob_connection_string
      secondary_blob_connection_string : azurerm_storage_account.storage.secondary_blob_connection_string
      identity : azurerm_storage_account.storage.identity
    }
  ]
}

