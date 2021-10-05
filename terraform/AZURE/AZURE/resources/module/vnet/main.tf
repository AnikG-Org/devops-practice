resource "azurerm_virtual_network" "vnet" {
  name                = "VNET-${upper(var.org)}-${upper(var.bu_code)}-${upper(var.component)}-${upper(var.app_env_code)}-${var.sequence_no}"
  address_space       = var.vnet_address_Space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
}
