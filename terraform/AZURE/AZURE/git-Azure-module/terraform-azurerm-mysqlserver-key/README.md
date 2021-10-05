# terraform-azurerm-mysqlserver-key

## Usage
``` terraform
data "azurerm_resource_group" "app_env_resource_group" {
  name = var.__ghs.environment_resource_groups
}

data "azurerm_key_vault" "key_vault" {
  name                = "mykeyvault"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

data "azurerm_key_vault_key" "key_vault_key" {
  name         = "secret-sauce"
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

data "azurerm_mysql_server" "mysql_server" {
  name                = "existingmysqlserver"
  resource_group_name = data.azurerm_resource_group.app_env_resource_group.name
}

module "mysqlserver_key" { 
  source              = "../../"
  server_id           = data.azurerm_mysql_server.mysql_server.id
  key_vault_key_id    = data.azurerm_key_vault_key.key_vault_key.id
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
| key\_vault\_key\_id | The URL to a Key Vault Key. | `string` | n/a | yes |
| server\_id | The ID of the MySQL Server. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | ID of the created MySQL server key. |

## Release Notes

The newest published version of this module is v1.0.0.

- View the complete change log [here](./changelog.md)
