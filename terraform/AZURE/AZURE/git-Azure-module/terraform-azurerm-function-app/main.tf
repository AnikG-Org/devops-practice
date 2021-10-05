resource "azurerm_function_app" "function_app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key

  os_type      = var.os_type
  app_settings = var.app_settings
  version      = var.function_app_version
  https_only   = true

  enable_builtin_logging  = var.enable_builtin_logging
  client_affinity_enabled = var.client_affinity_enabled
  daily_memory_time_quota = var.daily_memory_time_quota
  enabled                 = var.enabled

  site_config {
    pre_warmed_instance_count = (var.app_service_plan_sku_tier != null
      && contains(["Premium", "Isolated"], var.app_service_plan_sku_tier)
      ? var.pre_warmed_instance_count
      : null
    )

    dynamic "ip_restriction" {
      for_each = (var.ip_restrictions != null) ? var.ip_restrictions : []
      content {
        priority                  = ip_restriction.value.priority
        ip_address                = lookup(ip_restriction.value, "ip_address", null)
        virtual_network_subnet_id = lookup(ip_restriction.value, "subnet_id", null)
        name                      = lookup(ip_restriction.value, "name", null)
        action                    = lookup(ip_restriction.value, "action", "Allow")
      }
    }

    always_on                 = var.always_on
    ftps_state                = var.ftps_state
    http2_enabled             = var.http2_enabled
    linux_fx_version          = var.linux_fx_version
    min_tls_version           = var.min_tls_version
    use_32_bit_worker_process = var.use_32_bit_worker_process
    websockets_enabled        = var.websockets_enabled
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  lifecycle {
    ignore_changes = [
      app_settings,
    ]
  }

  tags = var.tags
}
