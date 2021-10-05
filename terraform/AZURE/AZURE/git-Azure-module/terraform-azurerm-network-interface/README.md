# terraform-azurerm-network-interface

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
  resource_group_name  = local.vnet_resource_group_name
}

module "network-interface" {
  source                         = "../../"
  resource_group_name            = data.azurerm_resource_group.app_env_resource_group.name
  name                           = var.user_parameters.naming_service.nic.k01
  location                       = "eastus"
  ip_address                     = "10.195.250.236"
  ip_config_name                 = "ipconfig1"
  subnet_id                      = data.azurerm_subnet.subnet.id
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
| ip\_address | A static IP address to be associated with the NIC's ip configuration. | `string` | n/a | yes |
| ip\_config\_name | The name of the IPconfig on the nic. | `string` | n/a | yes |
| location | The Azure region to deploy the NIC into. | `string` | n/a | yes |
| name | The name of the Network Interface. | `string` | n/a | yes |
| resource\_group\_name | Name of the resource group where resource is deployed to. | `string` | n/a | yes |
| subnet\_id | The subnet ID that the NIC will be associated to. | `string` | n/a | yes |
| tags | A map of key value pairs to be used when applying tags to the resource. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The nic id created in this module. |
| mac\_address | The media access control (MAC) address of the network interface. |
| name | Name of the nic that is created in this module. |
| private\_ip\_address | The first private IP address of the network interface. |
| private\_ip\_addresses | The private IP addresses of the network interface. |
| virtual\_machine\_id | Reference to a VM with which this NIC has been associated. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
