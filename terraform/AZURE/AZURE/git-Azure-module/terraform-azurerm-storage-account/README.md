# terraform-azurerm-storage-account

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

module "storage_account" {
  source                     = "../../"
  name                       = var.user_parameters.naming_service.storage.k01
  resource_group_name        = data.azurerm_resource_group.app_env_resource_group.name
  account_tier               = "Premium" # Possible values: Standard, Premium
  account_replication_type   = "LRS"      # Possible values: LRS, GRS, RAGRS, ZRS
  account_kind               = "StorageV2"
  location                   = data.azurerm_resource_group.app_env_resource_group.location
  default_action             = "Allow"
  ip_rules                   = []
  virtual_network_subnet_ids = []
  access_tier                = "Hot"
  bypass                     = []
  tags                       = local.tags
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
| location | The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions. | `string` | n/a | yes |
| name | Name of storage account to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which the storage account is to be created. | `string` | n/a | yes |
| tags | Map of tags to be attached to the resource group. | `map(string)` | n/a | yes |
| access\_tier | Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot. | `string` | `"Hot"` | no |
| account\_kind | Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2 | `string` | `"StorageV2"` | no |
| account\_replication\_type | Define the type of replication used for this storage account. | `string` | `"LRS"` | no |
| account\_tier | Define the storage account tier (Standard or Premium). | `string` | `"Standard"` | no |
| blob\_properties | Properties for blob storage | <pre>object({<br>    cors_rule = object({<br>      allowed_headers    = list(string),<br>      allowed_methods    = list(string),<br>      allowed_origins    = list(string),<br>      exposed_headers    = list(string),<br>      max_age_in_seconds = number<br>    })<br>  })</pre> | `null` | no |
| bypass | Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None. | `list(string)` | `[]` | no |
| containers | Optional list of map of container details to be created within the storage account. | <pre>list(object({<br>    name = string<br>    }<br>  ))</pre> | `[]` | no |
| custom\_domain | The custom domain to use for the Storage Account | <pre>object({<br>    name          = string<br>    use_subdomain = bool<br>  })</pre> | `null` | no |
| default\_action | Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow. | `string` | `"Deny"` | no |
| index\_document | The webpage that Azure Storage serves for requests to the root of a website or any subfolder. For example, index.html. The value is case-sensitive. | `string` | `null` | no |
| ip\_rules | List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed. | `list(string)` | `[]` | no |
| is\_hns\_enabled | Hierarchical Namespace to be enabled. | `bool` | `false` | no |
| min\_tls\_version | The minimum tls version should be TLS 1.2. | `string` | `"TLS1_2"` | no |
| tfe\_hostname | NGC TFE Instance e.g. https://example.tfe.pwcinternal.com | `string` | `null` | no |
| virtual\_network\_subnet\_ids | A list of resource ids for subnets. | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of storage account that is created |
| name | Name of storage account that is created |
| network\_rules\_id | ID of storage account network rules created |
| primary\_access\_key | Primary access key of storage account that is created |
| primary\_blob\_endpoint | Primary blob endpoint of storage account that is created |
| primary\_connection\_string | Primary Connection String of storage account that is created |
| primary\_web\_host | The hostname with port if applicable for web storage in the primary location. |
| secondary\_access\_key | Secondary access key of storage account that is created |
| storage\_accounts\_all | n/a |

## Release Notes

The newest published version of this module is v9.0.0.

- View the complete change log [here](./changelog.md)
