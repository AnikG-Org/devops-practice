resource "azurerm_container_registry" "container_registry" {
  count               = var.acr_count != 0 ? 1 : 0
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = var.admin_enabled
  tags                = var.tags
  
  dynamic "georeplications" {
   for_each = var.georeplications
    content {
      location = georeplications.value
    }
  }
}
