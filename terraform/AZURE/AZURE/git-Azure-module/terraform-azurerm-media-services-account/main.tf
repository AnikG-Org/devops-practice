resource "azurerm_media_services_account" "mediaservicesAccount" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_account {
    id         = var.storage_account_id
    is_primary = var.is_primary
  }
}
