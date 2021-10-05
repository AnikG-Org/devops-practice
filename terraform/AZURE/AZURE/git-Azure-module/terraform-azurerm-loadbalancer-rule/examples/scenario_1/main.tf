data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_lb" "lb" {
  name                = var.user_parameters.naming_service.lb.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_lb_backend_address_pool" "adpool" {
  name            = "BackEndAddressPool1"
  loadbalancer_id = data.azurerm_lb.lb.id
}

module "loadbalancer-rule" {
  source  = "../../"

  lb_rule_specs = [
    {
      name                           = "test"
      protocol                       = "tcp"
      frontend_port                  = "8080"
      backend_port                   = "8081"
      frontend_ip_configuration_name = "projectname-lb-nic"
    },
  ]

  resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
  loadbalancer_id         = data.azurerm_lb.lb.id
  load_distribution       = "Default"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.adpool.id
}
