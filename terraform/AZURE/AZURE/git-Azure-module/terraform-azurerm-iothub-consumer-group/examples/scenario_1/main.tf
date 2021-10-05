data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_iothub" "iothub" {
    name                    = "ngtestingiothub123"
    resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
}

module "iothub-consumer-group" {
  source                 = "../../"
  name                   = "ngtestingiothub123-consumer-group"
  iothub_name            = data.azurerm_iothub.iothub.name
  eventhub_endpoint_name = "events"
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
}
