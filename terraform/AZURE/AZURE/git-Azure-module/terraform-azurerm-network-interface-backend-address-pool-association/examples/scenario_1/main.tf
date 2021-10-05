data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_lb" "loadbalencer" {
  name                = var.user_parameters.naming_service.lb.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  name            = "BackEndAddressPool1"
  loadbalancer_id = data.azurerm_lb.loadbalencer.id
}

data "azurerm_network_interface" "network_interface" {
  name                = var.user_parameters.naming_service.nic.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "azurerm_network_interface_backend_address_pool_association" {
  source                  = "../../"
  nic_count               = "1"
  nic_ids                 = [data.azurerm_network_interface.network_interface.id]
  ip_configuration_name   = "ipconfig1"
  backend_address_pool_id = data.azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}
