# terraform-azurerm-datalake-analytics-account

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

data "azurerm_data_lake_store" "lake_store" {
  name                = var.user_parameters.naming_service.data_lake.dl01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "datalake-analytics-account" {
  source                           = "../../"
  resource_group_name              = data.azurerm_resource_group.app_env_resource_group.name
  location                         = "East US 2"
  data_lake_analytics_account_name = "dlanalaccountna"
  default_store_account_name       = data.azurerm_data_lake_store.lake_store.name
  tier                             = "Consumption"
  tags                             = local.tags
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
| data\_lake\_analytics\_account\_name | The name that will be used for the Data Lake Analytics account. | `string` | n/a | yes |
| default\_store\_account\_name | The Azure Data Lake store to use by default. Note that changing this value causes a new Data Lake Analytics account resource to be created. | `string` | n/a | yes |
| location | The Azure region where the Data Lake Analytics account is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group to create the Data Lake Analytics account in. | `string` | n/a | yes |
| tags | Map of tags to be attached to the Data Lake Analytics account | `map(string)` | n/a | yes |
| tier | The tier type of the Data Lake Analytics account to be created. Possible values: `Consumption`, `Commitment_100000AUHours`, `Commitment_10000AUHours`, `Commitment_1000AUHours`, `Commitment_100AUHours`, `Commitment_500000AUHours`, `Commitment_50000AUHours`, `Commitment_5000AUHours`, or `Commitment_500AUHours`. See https://azure.microsoft.com/en-us/pricing/details/data-lake-analytics/ for pricing details. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Cognitive Account created. |
| name | The name of the Data Lake Analytics account created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
