# terraform-azurerm-container-registry

## Usage
``` terraform
locals {
  vnet_resource_group_name = replace(var.system_parameters.VNET, "-VNT-", "-RGP-BASE-")
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

module "container-registry" {
  source                    = "../../"
  name                      = var.user_parameters.naming_service.container_registry.cr02
  location                  = var.__ghs.environment_hosting_region
  resource_group_name       = var.__ghs.environment_resource_groups
  sku                       = "Premium"               
  admin_enabled             = false
  georeplications           = ["West Europe"]
  tags                      = local.tags    
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
| name | The name of the Azure Container Registry. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Container Registry. | `string` | n/a | yes |
| tags | The tags associated to the resource. | `map(string)` | n/a | yes |
| acr\_count | Count based flag to decide weather to provision ACR or not. | `number` | `1` | no |
| admin\_enabled | Enable an admin user to use to push images to the ACR. | `string` | `false` | no |
| georeplications | A list of locations where the container registry should be geo-replicated. | `list(string)` | `[]` | no |
| sku | The SKU name of the the container registry. Possible values are Basic, Standard and Premium. If Firewall and virtual network option to be enable, please choose sku type as Premium. | `string` | `"Standard"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of newly created Azure Container Registry |
| login\_server | The server URL to push to the Container Registry |

## Release Notes

The newest published version of this module is v6.2.0.

- View the complete change log [here](./changelog.md)
