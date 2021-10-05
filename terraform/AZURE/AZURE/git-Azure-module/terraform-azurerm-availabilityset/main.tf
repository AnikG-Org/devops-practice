resource "azurerm_availability_set" "avs" {
  name                         = var.name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  managed                      = var.managed
  platform_update_domain_count = var.platform_update_domain_count
  platform_fault_domain_count  = var.platform_fault_domain_count
  tags                         = var.tags
}