locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "N-VNT", "N-RGP-BASE")
  tags = {
    "ghs-los" : var.system_parameters.TAGS.ghs-los,
    "ghs-solution" : var.system_parameters.TAGS.ghs-solution,
    "ghs-appid" : var.system_parameters.TAGS.ghs-appid,
    "ghs-solutionexposure" : var.system_parameters.TAGS.ghs-solutionexposure,
    "ghs-serviceoffering" : var.system_parameters.TAGS.ghs-serviceoffering,
    "ghs-environment" : var.system_parameters.TAGS.ghs-environment,
    "ghs-owner" : var.system_parameters.TAGS.ghs-owner,
    "ghs-apptioid" : var.system_parameters.TAGS.ghs-apptioid,
    "ghs-envid" : var.system_parameters.TAGS.ghs-envid,
    "ghs-tariff" : var.system_parameters.TAGS.ghs-tariff,
    "ghs-srid" : var.system_parameters.TAGS.ghs-srid,
    "ghs-environmenttype" : var.system_parameters.TAGS.ghs-environmenttype,
    "ghs-deployedby" : var.system_parameters.TAGS.ghs-deployedby,
    "ghs-dataclassification" : var.system_parameters.TAGS.ghs-dataclassification
  }
}

data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = local.vnet_resource_group_name
}

data "azurerm_network_interface" "nic" {
  name                = "ngnetworkinterface"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "load_balancer" {
  source                                 = "../../"
  name                                   = var.user_parameters.naming_service.lb.k02
  resource_group_name                    = data.azurerm_resource_group.app_env_resource_group.name
  location                               = data.azurerm_resource_group.app_env_resource_group.location
  sku                                    = "Standard"
  lb_frontend_ip_configuration_name      = "projectname-lb-nic"
  lb_frontend_ip_configuration_subnet_id = data.azurerm_subnet.subnet.id
  private_ip_address                     = "10.195.250.236"
  private_ip_address_allocation          = "Static"
 
  vm_nics   = [
    {
      nic_id               = data.azurerm_network_interface.nic.id
      ip_config_name       = "ipconfig1"
    }
  ]

  enable_floating_ip                  = false
  idle_timeout_minutes                = 5
  lb_probe_interval                   = 5
  lb_probe_unhealthy_threshold        = 3

  lb_ports = [
    {
      frontend_port = 80
      backend_port  = 80
      protocol      = "tcp"
      has_probe     = true
    },
    {
      frontend_port = 443
      backend_port  = 443
      protocol      = "tcp"
      has_probe     = true
    }
  ]

  lb_probe_ports = [
    {
      backend_port  = 80
      protocol      = "tcp"
    },
    {
      backend_port  = 443
      protocol      = "tcp"
    }
  ]

  tags = local.tags
}
