# terraform-azurerm-machine-learning-workspace

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

data "azurerm_application_insights" "example" {
  name                = var.user_parameters.naming_service.app_insights.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_key_vault" "example" {
  name                = var.user_parameters.naming_service.key_vault.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_storage_account" "example" {
  name                = var.user_parameters.naming_service.storage.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "mlworkspace" {
  source                  = "../../"
  mlworkspace_name        = var.user_parameters.naming_service.ml_workspace.k01
  resource_group_name     = data.azurerm_resource_group.app_env_resource_group.name
  location                = data.azurerm_resource_group.app_env_resource_group.location
  application_insights_id = data.azurerm_application_insights.example.id
  key_vault_id            = data.azurerm_key_vault.example.id
  storage_account_id      = data.azurerm_storage_account.example.id
  tags                    = local.tags
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
| application\_insights\_id | The ID of the Application Insights associated with this Machine Learning Workspace. | `string` | n/a | yes |
| key\_vault\_id | The ID of key vault associated with this Machine Learning Workspace. | `string` | n/a | yes |
| location | The supported Azure location where the Machine Learning Workspace should exist. | `string` | n/a | yes |
| mlworkspace\_name | The name of the Machine Learning Workspace. | `string` | n/a | yes |
| resource\_group\_name | The name of the Resource Group in which the Machine Learning Workspace should exist. | `string` | n/a | yes |
| storage\_account\_id | The ID of the Storage Account associated with this Machine Learning Workspace. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| container\_registry\_id | The ID of the container registry associated with this Machine Learning Workspace. | `string` | `null` | no |
| description | The description of this Machine Learning Workspace. | `string` | `""` | no |
| friendly\_name | Friendly name for this Machine Learning Workspace. | `string` | `null` | no |
| high\_business\_impact | Flag to signal High Business Impact (HBI) data in the workspace and reduce diagnostic data collected by the service | `string` | `null` | no |
| identity | The Type of Identity which should be used for this Disk Encryption Set. At this time the only possible value is SystemAssigned. | `string` | `"SystemAssigned"` | no |
| sku\_name | SKU/edition of the Machine Learning Workspace, possible values are Basic. Defaults to Basic. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Machine Learning Workspace |
| name | The Name of the Machine Learning Workspace |

## Release Notes

The newest published version of this module is v2.0.0.

- View the complete change log [here](./changelog.md)
