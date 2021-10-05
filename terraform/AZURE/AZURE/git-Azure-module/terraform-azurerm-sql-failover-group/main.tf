resource "azurerm_sql_failover_group" "sql_failover_group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  server_name         = var.primary_server_name
  databases           = var.databases

  partner_servers {
    id = var.secondary_server_id
  }

  dynamic "read_write_endpoint_failover_policy" {
    for_each = var.read_write_endpoint_failover_policy
    content {
      mode          = read_write_endpoint_failover_policy.value.read_write_mode
      grace_minutes = (read_write_endpoint_failover_policy.value.read_write_mode == "Automatic") ? read_write_endpoint_failover_policy.value.grace_minutes : null
    }
  }

  dynamic "readonly_endpoint_failover_policy" {
    for_each = var.readonly_endpoint_failover_policy
    content {
      mode = readonly_endpoint_failover_policy.value.readonly_mode
    }
  }

  tags = var.tags
}