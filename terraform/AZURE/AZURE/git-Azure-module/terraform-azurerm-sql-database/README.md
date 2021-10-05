# terraform-azurerm-sql-database

## Usage
``` terraform
locals {
  sql_server_name          = "u2zaevopsdsp001"
  sql_db_name_upper        = var.user_parameters.naming_service.sqldb.db01
  sql_db_name              = lower(local.sql_db_name_upper)
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

data "azurerm_storage_account" "storage_account" {
  name                = var.user_parameters.naming_service.storage.k01
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_sql_server" "sqlserver" {
  name                = "u2zoofmhstsp003"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "sql_database" {
  source                           = "../../"
  resource_group_name              = data.azurerm_resource_group.app_env_resource_group.name
  server_name                      = data.azurerm_sql_server.sqlserver.name
  name                             = "ngdbase1"
  db_edition                       = "Basic"              #Should select according to elastic pool edition
  requested_service_objective_name = "ElasticPool" 
  max_size_bytes                   = "2147483648"         #34359738368 for general purpose elasticpool
  location                         = data.azurerm_resource_group.app_env_resource_group.location
  read_scale                       = false
  zone_redundant                   = false
  elastic_pool_name                = "sqlelasticpool01"
  threat_detection_policy = [
    {
      state                      = "Enabled"
      disabled_alerts            = null
      email_account_admins       = null
      email_addresses            = ["fake.email@pwc.com"]
      retention_days             = 14
      storage_account_access_key = data.azurerm_storage_account.storage_account.primary_access_key
      storage_endpoint           = data.azurerm_storage_account.storage_account.primary_blob_endpoint
      use_server_default         = "Disabled"

    }
  ]
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
| db\_edition | The edition of the database to be created.Valid values are: Basic, Standard, Premium, or DataWarehouse. Please see (https://azure.microsoft.com/en-gb/documentation/articles/sql-database-service-tiers/). | `string` | n/a | yes |
| location | Specify the supported Azure location where the resource exists. | `string` | n/a | yes |
| name | The name of the database. | `string` | n/a | yes |
| requested\_service\_objective\_name | Use to set the performance level for the database.Valid values are: S0, S1, S2, S3, P1, P2, P4, P6, P11 and ElasticPool. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which to create the database. This must be the same as Database Server resource group currently. | `string` | n/a | yes |
| server\_name | he name of the SQL Server on which to create the database. | `string` | n/a | yes |
| threat\_detection\_policy | Threat detection policy configuration. | <pre>list(object({<br>    state                      = string<br>    disabled_alerts            = list(string)<br>    email_account_admins       = string<br>    email_addresses            = list(string)<br>    retention_days             = number<br>    storage_account_access_key = string<br>    storage_endpoint           = string<br>    use_server_default         = string<br>  }))</pre> | n/a | yes |
| collation | The name of the collation.Azure default is SQL\_LATIN1\_GENERAL\_CP1\_CI\_AS. Changing this forces a new resource to be created. | `string` | `"SQL_LATIN1_GENERAL_CP1_CI_AS"` | no |
| default\_rules | Whether or not to create the default rules | `bool` | `false` | no |
| elastic\_pool\_name | The name of the elastic database pool. | `string` | `""` | no |
| max\_size\_bytes | The maximum size that the database can grow to. Applies only if create\_mode is Default. | `string` | `"250000000000"` | no |
| read\_scale | Read-only connections will be redirected to a high-available replica | `bool` | `false` | no |
| tags | A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| zone\_redundant | Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| creation\_date | The Creation date of the SQL Database |
| default\_secondary\_location | The default secondary location of the SQL Database |
| id | The SQL Database ID created |

## Release Notes

The newest published version of this module is v7.2.0.

- View the complete change log [here](./changelog.md)
