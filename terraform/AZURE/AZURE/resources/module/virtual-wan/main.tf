resource "azurerm_virtual_wan" "virtual_wan" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = var.tags
}