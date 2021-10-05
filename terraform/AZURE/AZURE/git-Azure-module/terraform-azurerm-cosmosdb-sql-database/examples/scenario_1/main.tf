data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "u2zoofmhscos001"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "cosmosdbsqldb" {
  source                        = "../../"
  name                          = "ngccsomossqldb002"
  resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
  account_name                  = data.azurerm_cosmosdb_account.cosmosdb_account.name
  max_throughput                = 4000
}
