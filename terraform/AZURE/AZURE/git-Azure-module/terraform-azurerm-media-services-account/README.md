# terraform-azurerm-media-services-account

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_storage_account" "storage" {
  name                     = var.user_parameters.naming_service.storage.k01
  resource_group_name      = data.azurerm_resource_group.app_env_resource_group.name
}

module "media-services-account" {
       source                        = "../../"
       name                          = var.user_parameters.naming_service.media.k01
       location                      = data.azurerm_resource_group.app_env_resource_group.location
       resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
       storage_account_id            = data.azurerm_storage_account.storage.id
       is_primary                    = "true"
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
| location | Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| name | Specifies the name of the Media Services Account.Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the Media Services Account. Changing this forces a new resource to be created. | `string` | n/a | yes |
| storage\_account\_id | name of the storage\_account and storage\_account block supports the following below. | `string` | n/a | yes |
| is\_primary | Specifies whether the storage account should be the primary account or not. Defaults to false. | `string` | `"false"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The Resource ID of the Media Services Account. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
