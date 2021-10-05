resource "azurerm_storage_queue" "storagequeue" {
  name                 = var.name
  storage_account_name = var.storage_account_name
}

