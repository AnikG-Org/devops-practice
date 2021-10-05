resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

