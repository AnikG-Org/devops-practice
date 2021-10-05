# terraform-azurerm-nsg

## Usage
``` terraform
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

```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |
| terraform | >= 0.14 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| gateway\_subnet | The gateway subnet. | `string` | n/a | yes |
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions. | `string` | n/a | yes |
| name | Name of NSG to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of a resource group in which network security group is to be created. | `string` | n/a | yes |
| tags | A map of tags to be assigned to the network security group. | `map(string)` | n/a | yes |
| transit\_subnet | The transit subnet in CIDR notation. | `string` | n/a | yes |
| vnet\_address\_spaces | List of all address spaces on the vnet. This must be queried and provided as a list. | `list(string)` | n/a | yes |
| workload\_subnet | The workload subnet for the nsg. | `string` | n/a | yes |
| create\_default\_rules | Boolean flag to define if default NSG rules should be created. | `bool` | `true` | no |
| custom\_rules | Security rules for the network security group using this format = [name, direction, access, protocol, source\_port\_range, destination\_port\_range, source\_address\_prefix, destination\_address\_prefix] | <pre>list(object({<br>    name                       = string<br>    direction                  = string<br>    access                     = string<br>    protocol                   = string<br>    source_port_range          = string<br>    destination_port_range     = string<br>    source_address_prefix      = string<br>    destination_address_prefix = string<br>    }<br>  ))</pre> | `null` | no |
| nsg\_count | Defines if route table should be deployed (0 or 1) | `number` | `1` | no |
| smtp\_access | The value that determines 'allow' or 'deny' on the SMTP rule. Default value is Deny, use Allow to allow SMTP outbound traffic. | `string` | `"Deny"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of newly created network security group. |
| name | Name of newly created network security group. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
