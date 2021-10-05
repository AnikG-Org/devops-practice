# terraform-azurerm-monitor-action-group

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

module "monitor-action-group" {
  source              = "../../"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  name                = "APP-INSIGHTS-ACTION-GRP"
  short_name          = "ACTION-RGP"
  email_receivers = [
    {
      name          = "Tax AI"
      email_address = "xyz@yahoo.com"
    },
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
| name | The name of the Action Group. Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Action Group instance. | `string` | n/a | yes |
| short\_name | The short name of the action group. This will be used in SMS messages. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| email\_receivers | The name of the email receiver. Names must be unique (case-insensitive) across all receivers within an action group. | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The monitor action group id created |
| name | The monitor action group name created |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
