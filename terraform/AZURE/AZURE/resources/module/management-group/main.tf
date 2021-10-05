resource "azurerm_management_group" "management_group" {
  display_name = var.management_group_name

  subscription_ids = var.subscription_ids
}