# terraform-azurerm-cosmosdb-mongo-database

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "u2zoofmhscos002"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "cosmosdbmongodb" {
  source                        = "../../"
  name                          = "euszoofmhcosdb001"
  resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
  account_name                  = data.azurerm_cosmosdb_account.cosmosdb_account.name
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
| account\_name | The name of the CosmosDB account. Changing this forces a new resource to be created. | `string` | n/a | yes |
| name | The name of the CosmosDB Mongo Database. Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which the Cosmos DB Mongo Database is created. Changing this forces a new resource to be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The Cosmos DB Mongo Database ID. |
| name | The Cosmos DB Mongo Database name. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
