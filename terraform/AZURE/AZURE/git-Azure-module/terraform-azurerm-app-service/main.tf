resource "azurerm_app_service" "app_svc" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  app_service_plan_id = var.app_service_plan_id

  app_settings = var.app_settings
  https_only   = true

  client_cert_enabled     = var.client_cert_enabled
  client_affinity_enabled = var.client_affinity_enabled
  enabled                 = var.enabled



  site_config {
    dynamic "ip_restriction" {
      for_each = (var.ip_restrictions != null) ? var.ip_restrictions : []
      content {
        priority                  = ip_restriction.value.priority
        ip_address                = lookup(ip_restriction.value, "ip_address", null)
        service_tag               = lookup(ip_restriction.value, "service_tag", null)
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
    scm_type                  = var.scm_type
    use_32_bit_worker_process = var.use_32_bit_worker_process
    websockets_enabled        = var.websockets_enabled
    remote_debugging_enabled  = var.remote_debugging_enabled
    managed_pipeline_mode     = var.managed_pipeline_mode
    windows_fx_version        = var.windows_fx_version
    app_command_line          = var.app_command_line
    dotnet_framework_version  = var.dotnet_framework_version
    java_version              = var.java_version
    java_container            = var.java_container
    java_container_version    = var.java_container_version
    local_mysql_enabled       = var.local_mysql_enabled
    php_version               = var.php_version
    python_version            = var.python_version
    default_documents         = var.default_documents
    health_check_path         = var.health_check_path
    dynamic "cors" {
      for_each = (var.cors != null) ? var.cors : []
      content {
        allowed_origins     = lookup(cors.value, "allowed_origins", null)
        support_credentials = lookup(cors.value, "support_credentials", null)
      }
    }
  }

  identity {
    type         = var.identity_type
    identity_ids = var.identity_ids
  }

  dynamic "storage_account" {
    for_each = var.storage
    content {
      name         = storage_account.value.storage_name
      share_name   = storage_account.value.storage_share_name
      mount_path   = storage_account.value.storage_mount_path
      account_name = storage_account.value.storage_account_name
      type         = storage_account.value.storage_account_type
      access_key   = storage_account.value.storage_account_access_key
    }
  }

  lifecycle {
    ignore_changes = [
      app_settings,                    ## To ignore configuration variable changes pushed during application deployment
      site_config.0.linux_fx_version,  ## To ignore changes in container image version
      site_config.0.windows_fx_version ## To ignore changes in container image version
    ]
  }

  tags = var.tags
}

# App Service certificate
resource "azurerm_app_service_certificate" "app_service_certificate" {
  count               = length(var.custom_certificates)
  name                = var.custom_certificates[count.index].name
  resource_group_name = var.resource_group_name
  location            = var.location
  password            = var.custom_certificates[count.index].password
  pfx_blob            = filebase64(var.custom_certificates[count.index].pfx_blob)
  tags                = var.tags
  depends_on = [
    azurerm_app_service.app_svc
  ]
}

# Custom Hostname Binding

resource "azurerm_app_service_custom_hostname_binding" "custom_hostname_binding" {
  count               = length(var.custom_domains)
  hostname            = var.custom_domains[count.index]
  thumbprint          = azurerm_app_service_certificate.app_service_certificate[count.index].thumbprint
  ssl_state           = var.custom_certificates[count.index].ssl_state
  app_service_name    = azurerm_app_service.app_svc.name
  resource_group_name = var.resource_group_name
  depends_on = [
    azurerm_app_service.app_svc, azurerm_app_service_certificate.app_service_certificate
  ]
}

resource "azurerm_app_service_custom_hostname_binding" "managed_custom_hostname_binding" {
  count               = length(var.custom_managed_domains)
  hostname            = var.custom_managed_domains[count.index]
  app_service_name    = azurerm_app_service.app_svc.name
  resource_group_name = var.resource_group_name
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

resource "azurerm_app_service_custom_hostname_binding" "nocert_hostname_binding" {
  count               = length(var.custom_no_cert_domains)
  hostname            = var.custom_no_cert_domains[count.index]
  app_service_name    = azurerm_app_service.app_svc.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_app_service_managed_certificate" "managed_certificate" {
  count                      = length(var.custom_managed_domains)
  custom_hostname_binding_id = azurerm_app_service_custom_hostname_binding.managed_custom_hostname_binding[count.index].id
  tags                       = var.tags
}

resource "azurerm_app_service_certificate_binding" "managed_certificate_binding" {
  count               = length(var.custom_managed_domains)
  hostname_binding_id = azurerm_app_service_custom_hostname_binding.managed_custom_hostname_binding[count.index].id
  certificate_id      = azurerm_app_service_managed_certificate.managed_certificate[count.index].id
  ssl_state           = "SniEnabled"
}
