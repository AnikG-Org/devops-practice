resource "azurerm_resource_group" "rg_name" {
  name     = var.name
  location = var.location
  tags = var.tags
}