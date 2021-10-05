# terraform-azurerm-storage-queue

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_storage_account" "storage_account" {
  name                = "pzigxsus2ploofmht006"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "storage-queue" {
  source               = "../../"
  name                 = "storagequeue1"
  storage_account_name = data.azurerm_storage_account.storage_account.name
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
| name | Name of the queue to be created under resource group | `string` | n/a | yes |
| storage\_account\_name | Name of the storage account in which the storage queue is to be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of storage queue created |
| name | Name of the storage queue created |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
