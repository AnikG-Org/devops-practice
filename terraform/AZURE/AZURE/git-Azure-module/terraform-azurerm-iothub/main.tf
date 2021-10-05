resource "azurerm_storage_account" "azsa" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
}

resource "azurerm_storage_container" "azsc" {
  name = var.storage_container_name

  storage_account_name  = azurerm_storage_account.azsa.name
  container_access_type = var.container_access_type
}

resource "azurerm_iothub" "iothub" {
  name                = var.iothub_name
  resource_group_name = var.resource_group_name
  location            = var.location

  sku {
    name     = var.sku_name
    capacity = var.sku_capacity
  }

  endpoint {
    type                       = var.endpoint_type
    connection_string          = azurerm_storage_account.azsa.primary_blob_connection_string
    name                       = var.endpoint_name
    batch_frequency_in_seconds = var.batch_frequency_in_seconds
    max_chunk_size_in_bytes    = var.max_chunk_size_in_bytes
    container_name             = azurerm_storage_container.azsc.name
    encoding                   = var.endpoint_encoding
    file_name_format           = var.file_name_format
  }

  route {
    name           = var.route_name
    source         = var.route_source
    condition      = var.condition
    endpoint_names = var.endpoint_names
    enabled        = var.route_enabled
  }

  fallback_route {
    source         = var.fallback_source
    enabled        = var.fallback_enabled
    endpoint_names = var.endpoint_names
  }

  ip_filter_rule {
    name    = var.ipfilter_name
    ip_mask = var.ipfilter_ip_mask
    action  = var.iptilter_action
  }

  tags = var.tags
}

