resource "azurerm_data_lake_analytics_account" "data_lake_analytics_account" {
  name                       = var.data_lake_analytics_account_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  default_store_account_name = var.default_store_account_name
  tier                       = var.tier
  tags                       = var.tags
}