data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_logic_app_workflow" "logicappwf" {
  name                = var.user_parameters.naming_service.logic_app.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "logic-app-trigger-recurrence" {
  source                 = "../../"
  name                   = "triggerrecurrence"
  logic_app_id           = data.azurerm_logic_app_workflow.logicappwf.id
  frequency              = "Hour"
  interval               = 1
  resource_group_name    = data.azurerm_resource_group.app_env_resource_group.name
}
