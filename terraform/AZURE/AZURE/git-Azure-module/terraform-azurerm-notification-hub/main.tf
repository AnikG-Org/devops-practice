resource "azurerm_notification_hub" "notification_hub" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  namespace_name      = var.namespace_name
}

