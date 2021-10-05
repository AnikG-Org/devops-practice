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
