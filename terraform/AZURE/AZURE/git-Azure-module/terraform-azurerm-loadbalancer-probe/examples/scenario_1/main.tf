data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_lb" "lb" {
  name                = var.user_parameters.naming_service.lb.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}
module "loadbalancer-probe" {
  source              = "../../"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  loadbalancer_id     = data.azurerm_lb.lb.id
  name                = "testprobe"
  port                = 22
}
