# terraform-azurerm-datadisk

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

module "datadisk" {
  source              = "../../"
  location            = data.azurerm_resource_group.app_env_resource_group.location
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  vm_name             = "NGWINVMRSV001"
  vm_id               = "/subscriptions/4942ac67-943a-4f66-95ca-0068c4455040/resourceGroups/PZI-GXU2-N-RGP-OOFMH-D004/providers/Microsoft.Compute/virtualMachines/NGWINVMRSV001"
  datadisk_count      = 2
  data_disk_specs = [
    for index in range(2) : {
      storage_account_type = "Standard_LRS"
      disk_size_gb         = 256
    }
  ]
  zones               = ["3"]
  tags                = {
    "ghs-apptioid" = "12323"
  }
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
| data\_disk\_specs | Data disks deployment specifications | `list(map(string))` | n/a | yes |
| datadisk\_count | Number of  data disks to be created for the VM | `number` | n/a | yes |
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions | `string` | n/a | yes |
| resource\_group\_name | Name of existing resource group in which datadisks are to be created | `string` | n/a | yes |
| tags | A map of the tags to apply to the Azure resources. | `map(string)` | n/a | yes |
| vm\_id | Name of the virtual machine to which datadisks must be attached | `string` | n/a | yes |
| vm\_name | Name of the virtual machine to which datadisks must be attached | `string` | n/a | yes |
| caching | The caching type of the disk valid values are None, ReadOnly, and ReadWrite. The Default value is ReadWrite. | `string` | `"ReadWrite"` | no |
| zones | A collection containing the availability zone to allocate the Managed Disk in. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The resource id for the datadisk being deployed |
| name | The name for the datadisk being deployed |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
