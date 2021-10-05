data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_network_interface" "interface" {
  name                = var.user_parameters.naming_service.nic.k02
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_application_security_group" "asg" {
  name                = var.user_parameters.naming_service.asg.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "nic-asg-association" {
  source                        = "../../"
  nic_count                     = "1"
  nic_ids                       = [data.azurerm_network_interface.interface.id]
  application_security_group_id = data.azurerm_application_security_group.asg.id
}
