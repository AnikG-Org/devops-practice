resource "azurerm_postgresql_database" "pssql_database_01" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
 # location                    = var.location
  server_name                  = var.server_name
  charset                   = "UTF8"
  collation                 = "English_United States.1252"

  # extended_auditing_policy {
  #   storage_endpoint                        = azurerm_storage_account.example.primary_blob_endpoint
  #   storage_account_access_key              = azurerm_storage_account.example.primary_access_key
  #   storage_account_access_key_is_secondary = true
  #   retention_in_days                       = 6
  # }

}