# terraform-azurerm-sql-failover-group

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

data "azurerm_sql_server" "primary" {
  name                = "u2zoofmhsdsp006"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_sql_server" "secondary" {
  name                = "nezoofmhsdsp002"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_sql_database" "db1" {
  name                = "u2zoofmhsddb002"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
  server_name         = data.azurerm_sql_server.primary.name
}


module "sql_failover_group" {
  source                              = "../../"
  name                                = "ngcfailovergrouptest01"
  resource_group_name                 = data.azurerm_resource_group.app_env_resource_group.name
  primary_server_name                 = data.azurerm_sql_server.primary.name
  databases                           = [data.azurerm_sql_database.db1.id]
  secondary_server_id                 = data.azurerm_sql_server.secondary.id
  read_write_endpoint_failover_policy = [{
    read_write_mode                   = "Automatic"
    grace_minutes                     = 60
  }]
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
| databases | The Database ids to add to the failover group | `list(any)` | n/a | yes |
| name | The name of the failover group. | `string` | n/a | yes |
| primary\_server\_name | The name of the primary SQL server. | `string` | n/a | yes |
| read\_write\_endpoint\_failover\_policy | n/a | <pre>list(object(<br>    {<br>      read_write_mode = string,<br>      grace_minutes   = string<br>    }<br>  ))</pre> | n/a | yes |
| resource\_group\_name | The name of the resource group containing the SQL server | `string` | n/a | yes |
| secondary\_server\_id | The SQL server ID | `string` | n/a | yes |
| tags | Map of tags to be attached to the resource group. | `map(string)` | n/a | yes |
| readonly\_endpoint\_failover\_policy | n/a | <pre>list(object(<br>    {<br>      readonly_mode = string<br>    }<br>  ))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The id of the failover group. |
| name | The name of the failover group. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
