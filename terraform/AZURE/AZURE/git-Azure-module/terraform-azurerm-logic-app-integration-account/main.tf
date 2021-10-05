resource "azurerm_logic_app_integration_account" "logic_app_integration_account" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  tags = var.tags
}
