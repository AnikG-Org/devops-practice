data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_storage_account" "storage" {
  name                     = var.user_parameters.naming_service.storage.k01
  resource_group_name      = data.azurerm_resource_group.app_env_resource_group.name
}

module "media-services-account" {
       source                        = "../../"
       name                          = var.user_parameters.naming_service.media.k01
       location                      = data.azurerm_resource_group.app_env_resource_group.location
       resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
       storage_account_id            = data.azurerm_storage_account.storage.id
       is_primary                    = "true"
}
