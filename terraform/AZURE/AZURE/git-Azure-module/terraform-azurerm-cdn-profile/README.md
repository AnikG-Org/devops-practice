# terraform-azurerm-cdn-profile

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

module "cdn-profile" {
  source              = "../../"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  location            = data.azurerm_resource_group.app_env_resource_group.location
  cdn_profile_name    = var.user_parameters.naming_service.cdnprofile.k01
  sku_type            = "Standard_Verizon"

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
| cdn\_profile\_name | The name that will be used for the CDN profile. | `string` | n/a | yes |
| location | The Azure region where the CDN profile is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| resource\_group\_name | Resource group name in which the CDN profile will be created | `string` | n/a | yes |
| sku\_type | The sku type of the CDN profile to be created. Possible values: 'Standard\_Akamai', 'Standard\_ChinaCdn', 'Standard\_Microsoft', 'Standard\_Verizon', and 'Premium\_Verizon' | `string` | n/a | yes |
| tags | Map of tags to be attached to the CDN profile | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the CDN profile created. |
| name | The name of the CDN profile created. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
