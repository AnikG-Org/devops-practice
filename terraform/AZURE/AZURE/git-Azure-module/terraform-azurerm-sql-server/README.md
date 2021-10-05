# terraform-azurerm-sql-server

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

data "azurerm_virtual_network" "vnet" {
  name                = var.system_parameters.VNET
  resource_group_name = local.vnet_resource_group_name
}

data "azurerm_subnet" "subnet" {
  name                 = "PZI-GXUS-G-SNT-OOFMH-T015"
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_virtual_network.vnet.resource_group_name
}

data "azurerm_storage_account" "storage_account" {
  name                = var.user_parameters.naming_service.storage.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "sql-server" {
  source                       = "../../"
  resource_group_name          = data.azurerm_resource_group.app_env_resource_group.name
  name                         = var.user_parameters.naming_service.sql_server.k01
  administrator_login_username = "ngadmin"
  administrator_login_password = "Passw0rd@123"
  location                     = data.azurerm_resource_group.app_env_resource_group.location
  storage_endpoint             = data.azurerm_storage_account.storage_account.primary_blob_endpoint
  storage_account_access_key   = data.azurerm_storage_account.storage_account.primary_access_key
  ad_administrator_login       = "AzureAD Admin"
  ad_administrator_object_id   = "xxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
  tags                         = local.tags 
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
| administrator\_login\_password | The password associated with the administrator\_login user. Needs to comply with Azure's Password Policy. | `string` | n/a | yes |
| administrator\_login\_username | The administrator login name for the new server. | `string` | n/a | yes |
| location | Specifies the supported Azure location where the resource exists. | `string` | n/a | yes |
| name | The name of the SQL Server. This needs to be globally unique within Azure. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the SQL Server. | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource. | `map(string)` | n/a | yes |
| ad\_administrator\_login | Login name of a user or a group that will be AD administrator for an Azure SQL server. Must be set together with ad\_administrator\_object\_id. | `string` | `null` | no |
| ad\_administrator\_object\_id | Object ID of a user or a group that will be AD administrator for an Azure SQL server. Must be set together with ad\_administrator\_login. | `string` | `null` | no |
| connection\_policy | The connection policy the server will use. Possible values are Default, Proxy, and Redirect. | `string` | `"Default"` | no |
| create\_mode | Specifies how to create the database. Valid values are: Default, Copy, OnlineSecondary, NonReadableSecondary, PointInTimeRestore, Recovery, Restore or RestoreLongTermRetentionBackup. | `string` | `"Default"` | no |
| database\_names | List of database names to be created on the SQL server. | `list(string)` | `[]` | no |
| edition | The edition of the database to be created. | `string` | `null` | no |
| firewall\_rules | List of firewall rules to be attached to the SQL server. | <pre>list(object({<br>    name             = string<br>    start_ip_address = string<br>    end_ip_address   = string<br>  }))</pre> | `[]` | no |
| identity\_type | Specifies the identity type of the Microsoft SQL Server. At this time the only allowed value is SystemAssigned. | `string` | `"SystemAssigned"` | no |
| max\_size\_bytes | The maximum size that the database can grow to. | `number` | `null` | no |
| requested\_service\_objective\_name | The service objective name for the database. Valid values depend on edition and location and may include S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool. | `string` | `null` | no |
| retention\_in\_days | Specifies the number of days to retain logs for in the storage account. | `number` | `null` | no |
| sql\_version | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). | `string` | `"12.0"` | no |
| storage\_account\_access\_key | Specifies the access key to use for the auditing storage account. | `string` | `null` | no |
| storage\_account\_access\_key\_is\_secondary | Specifies whether storage\_account\_access\_key value is the storage's secondary key. | `bool` | `false` | no |
| storage\_endpoint | Specifies the blob storage endpoint | `string` | `null` | no |
| vnet\_rules | List of vnet rules to be attached to the SQL server. | <pre>list(object({<br>    name      = string<br>    subnet_id = string<br>  }))</pre> | `[]` | no |
| zone\_redundant | Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| db\_ids | The SQL dabase IDs |
| fqdn | The fully qualified domain name of the Azure SQL Server (e.g. myServerName.database.windows.net) |
| id | The SQL Server ID |
| identity | The SQL Server identity |
| name | The name of the sql server |

## Release Notes

The newest published version of this module is v7.0.0.

- View the complete change log [here](./changelog.md)
