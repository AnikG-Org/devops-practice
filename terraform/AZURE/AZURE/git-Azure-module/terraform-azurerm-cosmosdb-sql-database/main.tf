resource "azurerm_cosmosdb_sql_database" "cosmosdb_sql_database" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.account_name
  throughput          = var.throughput
  dynamic "autoscale_settings" {
    for_each = (var.max_throughput != null) ? [""] : []
    content {
      max_throughput = var.max_throughput
    }
  }
}
