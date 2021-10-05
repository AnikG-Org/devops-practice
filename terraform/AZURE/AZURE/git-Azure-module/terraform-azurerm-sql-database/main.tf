
resource "azurerm_sql_database" "db" {
  name                             = var.name
  resource_group_name              = var.resource_group_name
  location                         = var.location
  server_name                      = var.server_name
  create_mode                      = "Default"
  edition                          = var.db_edition
  collation                        = var.collation
  requested_service_objective_name = var.requested_service_objective_name
  tags                             = var.tags
  max_size_bytes                   = var.max_size_bytes
  read_scale                       = var.read_scale
  zone_redundant                   = var.zone_redundant
  elastic_pool_name                = var.elastic_pool_name

  dynamic "threat_detection_policy" {
    for_each = var.threat_detection_policy

    content {
      state                      = threat_detection_policy.value.state
      disabled_alerts            = threat_detection_policy.value.disabled_alerts
      email_account_admins       = threat_detection_policy.value.email_account_admins
      email_addresses            = threat_detection_policy.value.email_addresses
      retention_days             = threat_detection_policy.value.retention_days
      storage_account_access_key = threat_detection_policy.value.storage_account_access_key
      storage_endpoint           = threat_detection_policy.value.storage_endpoint
      use_server_default         = threat_detection_policy.value.use_server_default
    }
  }

}
