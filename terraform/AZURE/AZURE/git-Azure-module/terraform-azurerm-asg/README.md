# terraform-azurerm-asg

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

module "asg" {
  source = "../../"
  name                  = var.user_parameters.naming_service.asg.k01
  resource_group_name   = data.azurerm_resource_group.app_env_resource_group.name
  location              = data.azurerm_resource_group.app_env_resource_group.location
  tags                  = local.tags
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
| location | The Azure region where the ASG is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions. | `string` | n/a | yes |
| name | Name of the ASG to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the ASG. | `string` | n/a | yes |
| tags | Map of tags to be attached to the ASG. | `map(string)` | n/a | yes |
| asg\_count | Count used as a flag to define if ASG should be deployed. | `number` | `1` | no |
| nic\_ids | List of NIC Id's to be associated to the ASG. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Application Security Group. |
| name | The name of the Application Security Group. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
