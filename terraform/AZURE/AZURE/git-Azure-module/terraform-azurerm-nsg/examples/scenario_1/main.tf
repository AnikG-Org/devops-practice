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
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

# Use the NSG crowdsourcing module
module "nsg" {
  source                  = "../../"
  resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
  name                    = var.user_parameters.naming_service.nsg.k01
  location                = data.azurerm_resource_group.app_env_resource_group.location
  workload_subnet         = "*"
  gateway_subnet          = "*"
  transit_subnet          = "*"
  vnet_address_spaces     = ["10.1.0.6","10.1.0.7"]
  custom_rules            = [
          {
            name                       = "customrule1"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule2"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule3"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule4"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule5"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule6"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule7"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule8"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule9"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule10"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule11"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        },
        {
            name                       = "customrule12"
            direction                  = "inbound"
            access                     = "allow"
            protocol                   = "*"
            source_port_range          = "*"
            destination_port_range     = "*"
            source_address_prefix      = "*"
            destination_address_prefix = "*"    
        }
    ]
 tags = local.tags
}
