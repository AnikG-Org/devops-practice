data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "u2zoofmhscos002"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "cosmosdbmongodb" {
  source                        = "../../"
  name                          = "euszoofmhcosdb001"
  resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
  account_name                  = data.azurerm_cosmosdb_account.cosmosdb_account.name
}