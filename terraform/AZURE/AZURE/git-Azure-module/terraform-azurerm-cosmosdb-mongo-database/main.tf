resource "azurerm_cosmosdb_mongo_database" "cosmosdb_mongo_database" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.account_name
}

