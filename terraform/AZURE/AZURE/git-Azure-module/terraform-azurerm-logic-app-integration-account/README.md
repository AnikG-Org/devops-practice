# terraform-azurerm-logic-app-integration-account

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

module "integration_account" {
  source = "../../"

  name                = "integrationaccountname"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  location            = data.azurerm_resource_group.app_env_resource_group.location

  sku_name = "Standard"

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
| location | The Azure region where the Logic App Integration Account is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions. | `string` | n/a | yes |
| name | Name of the Logic App Integration Account to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which the Logic App Integration Account is to be created. | `string` | n/a | yes |
| tags | Map of tags to be attached to the Logic App Integration Account. | `map(string)` | n/a | yes |
| sku\_name | The sku name of the Logic App Integration Account. Possible values are Basic, Free and Standard. Default is Basic. | `string` | `"Basic"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | Id of Logic App Integration Account that is created |

## Release Notes

The newest published version of this module is v1.0.0.

- View the complete change log [here](./changelog.md)
