# terraform-azurerm-service-bus

## Usage
``` terraform
locals {
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

module "service_bus" {
  source              = "../../"
  name                = var.user_parameters.naming_service.service_bus.k04
  location            = "East US"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  sku_name            = "Premium"
  capacity            = 1
  zone_redundant      = true
  tags                = local.tags
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
| location | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| name | Specifies the name of the ServiceBus Namespace resource. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the namespace. | `string` | n/a | yes |
| sku\_name | Defines which tier to use. Options are basic, standard or premium. | `string` | n/a | yes |
| tags | Map of tags to be attached to the service bus. | `map(string)` | n/a | yes |
| capacity | Specifies the capacity. When sku is Premium, capacity can be 1, 2, 4 or 8. When sku is Basic or Standard, capacity can be 0 only. | `number` | `null` | no |
| zone\_redundant | Whether or not this resource is zone redundant. sku needs to be Premium. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_primary\_connection\_string | The primary connection string for the authorization rule RootManageSharedAccessKey. |
| default\_primary\_key | The primary access key for the authorization rule RootManageSharedAccessKey. |
| default\_secondary\_connection\_string | The secondary connection string for the authorization rule RootManageSharedAccessKey. |
| default\_secondary\_key | The secondary access key for the authorization rule RootManageSharedAccessKey. |
| id | Service bus namespace ID. |
| name | Service bus namespace. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
