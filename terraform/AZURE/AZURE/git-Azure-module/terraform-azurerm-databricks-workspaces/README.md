# terraform-azurerm-databricks-workspaces

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

module "databricks-workspace" {
  source                      = "../../"
  name                        = "pzigxsus2dbwawocp01"
  resource_group_name         = data.azurerm_resource_group.app_env_resource_group.name
  location                    = var.__ghs.environment_hosting_region
  sku                         = "standard"
  managed_resource_group_name = "managedrg"
  tags =  local.tags
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
| location | Azure location | `string` | n/a | yes |
| managed\_resource\_group\_name | The name of the resource group where Azure should place the Databricks resource | `string` | n/a | yes |
| name | Name of databricks workspace | `string` | n/a | yes |
| resource\_group\_name | Resource group name to place the resource | `string` | n/a | yes |
| private\_subnet\_name | databricks private subnet | `string` | `""` | no |
| public\_subnet\_name | databricks public subnet | `string` | `""` | no |
| sku | Choose between Basic or Standard. Default is Basic | `string` | `"Standard"` | no |
| tags | The tags associated to the resource | `map` | `{}` | no |
| virtual\_network\_id | databricks vnet | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of newly created workspace |
| managed\_resource\_group\_id | The assigned id of the resource group id where the resource is to be placed. |

## Release Notes

The newest published version of this module is v5.0.1.

- View the complete change log [here](./changelog.md)
