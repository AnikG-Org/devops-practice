resource "random_id" "server" {
  keepers = {
    azi_id = 1
  }

  byte_length = 8
}
resource "azurerm_traffic_manager_profile" "traffic_manager" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.traffic_routing_method

  dns_config {
    relative_name = random_id.server.hex
    ttl           = var.ttl
  }

  monitor_config {
    protocol                     = var.protocol
    port                         = var.port
    path                         = var.path
    interval_in_seconds          = var.interval_in_seconds
    timeout_in_seconds           = var.timeout_in_seconds
    tolerated_number_of_failures = var.tolerated_failures
  }

  tags = var.tags
}


