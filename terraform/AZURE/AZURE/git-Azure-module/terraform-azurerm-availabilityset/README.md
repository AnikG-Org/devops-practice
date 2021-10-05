# terraform-azurerm-availabilityset

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

module "availabilityset" {
  source                       = "../../"
  name                         = var.user_parameters.naming_service.availabilityset.k01
  resource_group_name          = data.azurerm_resource_group.app_env_resource_group.name
  location                     = data.azurerm_resource_group.app_env_resource_group.location
  managed                      = true
  platform_fault_domain_count  = 3
  platform_update_domain_count = 3

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
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| name | Name of availability set to be created. | `string` | n/a | yes |
| resource\_group\_name | Name of existing resource group in which availability set is to be created. | `string` | n/a | yes |
| tags | A map of tags to be assigned to availability set. | `map(string)` | n/a | yes |
| managed | Specifies whether the availability set is managed or not.Possible values are true or false. | `bool` | `true` | no |
| platform\_fault\_domain\_count | Specifies the number of fault domains that are used. Defaults to 3 if not specified. | `number` | `3` | no |
| platform\_update\_domain\_count | Specifies the number of update domains that are used. Defaults to 5 if not specified. | `number` | `5` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of availability set that is created |
| name | Name of availability set created |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
