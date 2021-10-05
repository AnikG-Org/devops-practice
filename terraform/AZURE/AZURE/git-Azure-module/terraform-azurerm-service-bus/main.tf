resource "azurerm_servicebus_namespace" "servicebus" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku_name
  capacity            = var.sku_name != "Premium" ? 0 : var.capacity
  zone_redundant      = var.zone_redundant
  tags                = var.tags
}
