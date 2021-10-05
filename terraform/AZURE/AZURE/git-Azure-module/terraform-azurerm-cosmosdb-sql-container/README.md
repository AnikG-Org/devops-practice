# terraform-azurerm-cosmosdb-sql-container

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = "u2zoofmhscos001"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "cosmosdb-sql-container" {
  source                        = "../../"
  name                          = "ngcosmossqlcont003"
  resource_group_name           = data.azurerm_resource_group.app_env_resource_group.name
  account_name                  = data.azurerm_cosmosdb_account.cosmosdb_account.name
  database_name                 = "ngccsomossqldb002" 
  partition_key_path            = "/definition/id"
  max_throughput                = 4000
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
| account\_name | The name of the Cosmos DB Account to create the container within. Changing this forces a new resource to be created. | `string` | n/a | yes |
| database\_name | The name of the Cosmos DB SQL Database to create the container within. Changing this forces a new resource to be created. | `string` | n/a | yes |
| name | The name of the CosmosDB SQL container. Changing this forces a new resource to be created. | `string` | n/a | yes |
| partition\_key\_path | Define a partition key. Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_group\_name | The name of the resource group in which the Cosmos DB SQL container is created. Changing this forces a new resource to be created. | `string` | n/a | yes |
| max\_throughput | The maximum throughput of the SQL container (RU/s). Must be between 4,000 and 1,000,000. Must be set in increments of 1,000. Conflicts with throughput. | `number` | `null` | no |
| throughput | The throughput of SQL container (RU/s). Must be set in increments of 100. The minimum value is 400. | `number` | `null` | no |
| unique\_key | A list of paths to use for this unique key. | `any` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The Cosmos DB SQL container ID. |
| name | The Cosmos DB SQL container name. |

## Release Notes

The newest published version of this module is v6.0.0.

- View the complete change log [here](./changelog.md)
