data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "u2zoofmhscos001"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "cosmosdb-sql-container" {
  source                        = "../../"
  name                          = "ngcosmossqlcont003"
  resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
  account_name                  = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name                 = "ngccsomossqldb002" 
  partition_key_path            = "/definition/id"
  max_throughput                = 4000
}
