data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_storage_account" "storage_account" {
  name                = "pzigxsus2ploofmht006"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "storage-queue" {
  source               = "../../"
  name                 = "storagequeue1"
  storage_account_name = data.azurerm_storage_account.storage_account.name
}
