# terraform-azurerm-recoveryservicevault

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

module "recoveryservicevault" {
  source                          = "../../"
  name                            = var.user_parameters.naming_service.recovery_services_vault.k02
  resource_group_name             = data.azurerm_resource_group.app_env_resource_group.name
  location                        = var.__ghs.environment_hosting_region
  sku                             = "Standard"
  soft_delete_enabled             = false
  monitor_diagnostic_setting_name = "ngctest123"
  tfe_url                         = "tfe.pwc.com"
  tags                            = local.tags
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
| location | Specify the supported Azure location where the resource exists. | `string` | n/a | yes |
| monitor\_diagnostic\_setting\_name | Specifies the name of the Diagnostic Setting. | `string` | n/a | yes |
| name | Name of the recovery service vault. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Recovery Services Vault. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| tfe\_url | Specify TFE instance url like: west.tfe.pwcinternal.com, central.tfe.pwcinternal.com, east.tfe.pwcinternal.com, tfe.pwc.com and global.tfe.pwcinternal.com | `string` | n/a | yes |
| sku | Sets the vault's SKU. Possible values include: Standard, RS0. | `string` | `"Standard"` | no |
| soft\_delete\_enabled | Is soft delete enable for this Vault? If 'true' the backup data is retained for 14 additional days and VM deletion won't happen instantaneously, If 'false' VM resource get deleted instantaneously | `string` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| monitor\_diagnostic\_id | The ID of the Diagnostic Setting |
| recovery\_services\_vault\_id | The ID of the Recovery Services Vault created. |
| recovery\_services\_vault\_name | The Name of the Recovery Services Vault created. |

## Release Notes

The newest published version of this module is v8.0.0.

- View the complete change log [here](./changelog.md)
