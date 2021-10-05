resource "azurerm_sql_server" "sql_server" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.administrator_login_username
  administrator_login_password = var.administrator_login_password
  connection_policy            = var.connection_policy
  identity {
    type = var.identity_type
  }

  dynamic "extended_auditing_policy" {
    for_each = var.storage_account_access_key != null && var.storage_endpoint != null ? [""] : []
    content {
      storage_account_access_key              = var.storage_account_access_key
      storage_endpoint                        = var.storage_endpoint
      storage_account_access_key_is_secondary = var.storage_account_access_key_is_secondary
      retention_in_days                       = var.retention_in_days
    }
  }

  tags = var.tags
}

resource "azurerm_sql_firewall_rule" "firewall_rules" {
  count               = var.firewall_rules == [] ? 0 : length(var.firewall_rules)
  name                = var.firewall_rules[count.index]["name"]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  start_ip_address    = var.firewall_rules[count.index]["start_ip_address"]
  end_ip_address      = var.firewall_rules[count.index]["end_ip_address"]
}

resource "azurerm_sql_virtual_network_rule" "vnet_rules" {
  count               = var.vnet_rules == [] ? 0 : length(var.vnet_rules)
  name                = var.vnet_rules[count.index]["name"]
  resource_group_name = var.resource_group_name
  server_name         = azurerm_sql_server.sql_server.name
  subnet_id           = var.vnet_rules[count.index]["subnet_id"]
}

resource "azurerm_sql_database" "databases" {
  count                            = length(var.database_names)
  name                             = element(var.database_names, count.index)
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = azurerm_sql_server.sql_server.name
  create_mode                      = var.create_mode
  edition                          = var.edition
  requested_service_objective_name = var.requested_service_objective_name
  zone_redundant                   = var.zone_redundant
  max_size_bytes                   = var.create_mode == "Default" ? var.max_size_bytes : null
  ## SQL DB supports only 15 tags, use first 15 tags if more than 15 are supplied
  tags = length(keys(var.tags)) > 15 ? zipmap(slice(keys(var.tags), 0, 14), slice(values(var.tags), 0, 14)) : var.tags
}

data "azurerm_client_config" "current" {}

resource "azurerm_sql_active_directory_administrator" "sql_active_directory_administrator" {
  count               = (var.ad_administrator_login == null || var.ad_administrator_object_id == null) ? 0 : 1
  server_name         = azurerm_sql_server.sql_server.name
  resource_group_name = var.resource_group_name
  login               = var.ad_administrator_login
  object_id           = var.ad_administrator_object_id
  tenant_id           = data.azurerm_client_config.current.tenant_id
}