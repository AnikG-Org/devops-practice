resource "azurerm_cosmosdb_sql_container" "cosmosdb_sql_container" {
  name                = var.name
  resource_group_name = var.resource_group_name
  account_name        = var.account_name
  database_name       = var.database_name
  partition_key_path  = var.partition_key_path
  throughput          = var.throughput
  dynamic "autoscale_settings" {
    for_each = (var.max_throughput != null) ? [""] : []
    content {
      max_throughput = var.max_throughput
    }
  }
  dynamic "unique_key" {
    for_each = var.unique_key
    content {
      paths           = unique_key.value.paths
    }
  }
}
