# terraform-azurerm-virtual-machine-extension

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

data "azurerm_virtual_machine" "example" {
  name                = var.user_parameters.naming_service.custom_linux.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "virtual_machine_extension" {
  source               = "../../"
  name                 = var.user_parameters.naming_service.custom_vm_extension.k01
  virtual_machine_id   = data.azurerm_virtual_machine.example.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"
  settings             = "\"commandToExecute\": \"hostname && uptime\""
  protected_settings   = ""
  tags                 = local.tags
}


```

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12 |
| terraform | >= 0.14 |
| azurerm | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the virtual machine extension peering | `string` | n/a | yes |
| publisher | The publisher of the extension | `string` | n/a | yes |
| type | The type of extension | `string` | n/a | yes |
| type\_handler\_version | Specifies the version of the extension to use | `string` | n/a | yes |
| virtual\_machine\_id | The ID of the Virtual Machine. Changing this forces a new resource to be created | `string` | n/a | yes |
| auto\_upgrade\_minor\_version | Specifies if the platform deploys the latest minor version update to the type\_handler\_version specified. | `string` | `null` | no |
| protected\_settings | The protected\_settings passed to the extension, like settings, these are specified as a JSON object in a string. | `string` | `""` | no |
| settings | The settings passed to the extension, these are specified as a JSON object in a string. | `string` | `""` | no |
| tags | Mapping of tags to assign to the resource. | `map(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Virtual Machine Extension |

## Release Notes

The newest published version of this module is v7.0.0.

- View the complete change log [here](./changelog.md)
