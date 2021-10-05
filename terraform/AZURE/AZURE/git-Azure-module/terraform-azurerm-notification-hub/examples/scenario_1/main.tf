data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_notification_hub_namespace" "hub_namespace" {
  name                = "ngchubeusoofmh001"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "notification-hub" {
  source                 = "../../"
  name                   = var.user_parameters.naming_service.notification_hub.k01
  location               = var.__ghs.environment_hosting_region
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
  namespace_name         = data.azurerm_notification_hub_namespace.hub_namespace.name
}