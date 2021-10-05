data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_logic_app_workflow" "httprequest" {
  name                = var.user_parameters.naming_service.logic_app.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "logic-app-trigger-http-request" {
  source              = "../../"
  name                = "actionhttprequest"
  logic_app_id        = data.azurerm_logic_app_workflow.httprequest.id
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  filename            = "var.json"
}