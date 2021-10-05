output "id" {
  value = azurerm_storage_account.storage_account.id
}
output "storage_datalake_id" {
  value = azurerm_storage_data_lake_gen2_filesystem.file_01.id
}
