resource "azurerm_api_management" "api_management" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email

  sku_name = var.sku_name

  dynamic "virtual_network_configuration" {
    for_each = (var.virtual_network_type != "None") ? [var.subnet_id] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  dynamic "certificate" {
    for_each = (var.certificates != null) ? var.certificates : []
    content {
      encoded_certificate  = certificate.value["b64_pfx_cert_data"]
      certificate_password = certificate.value["certificate_password"]
      store_name           = lookup(certificate.value, "store_name", "Root")
    }
  }

  dynamic "identity" {
    for_each = var.identity
    content {
      type         = lookup(identity.value, "type", "SystemAssigned")
      identity_ids = identity.value.ids
    }
  }

  dynamic "hostname_configuration" {
    for_each = (var.hostname_config != null) ? [var.hostname_config] : []
    content {
      management {
        host_name                    = hostname_configuration.value.management["host_name"]
        key_vault_id                 = lookup(hostname_configuration.value.management, "key_vault_id", null)
        certificate                  = lookup(hostname_configuration.value.management, "certificate", null)
        certificate_password         = lookup(hostname_configuration.value.management, "certificate_password", null)
        negotiate_client_certificate = lookup(hostname_configuration.value.management, "negotiate_client_certificate", null)
      }

      developer_portal {
        host_name                    = hostname_configuration.value.dev_portal["host_name"]
        key_vault_id                 = lookup(hostname_configuration.value.dev_portal, "key_vault_id", null)
        certificate                  = lookup(hostname_configuration.value.dev_portal, "certificate", null)
        certificate_password         = lookup(hostname_configuration.value.dev_portal, "certificate_password", null)
        negotiate_client_certificate = lookup(hostname_configuration.value.dev_portal, "negotiate_client_certificate", null)
      }

      portal {
        host_name                    = hostname_configuration.value.portal["host_name"]
        key_vault_id                 = lookup(hostname_configuration.value.portal, "key_vault_id", null)
        certificate                  = lookup(hostname_configuration.value.portal, "certificate", null)
        certificate_password         = lookup(hostname_configuration.value.portal, "certificate_password", null)
        negotiate_client_certificate = lookup(hostname_configuration.value.portal, "negotiate_client_certificate", null)
      }

      scm {
        host_name                    = hostname_configuration.value.scm["host_name"]
        key_vault_id                 = lookup(hostname_configuration.value.scm, "key_vault_id", null)
        certificate                  = lookup(hostname_configuration.value.scm, "certificate", null)
        certificate_password         = lookup(hostname_configuration.value.scm, "certificate_password", null)
        negotiate_client_certificate = lookup(hostname_configuration.value.scm, "negotiate_client_certificate", null)
      }

      proxy {
        default_ssl_binding          = lookup(hostname_configuration.value.proxy, "default_ssl_binding", null)
        host_name                    = hostname_configuration.value.proxy["host_name"]
        key_vault_id                 = lookup(hostname_configuration.value.proxy, "key_vault_id", null)
        certificate                  = lookup(hostname_configuration.value.proxy, "certificate", null)
        certificate_password         = lookup(hostname_configuration.value.proxy, "certificate_password", null)
        negotiate_client_certificate = lookup(hostname_configuration.value.proxy, "negotiate_client_certificate", null)
      }
    }
  }

  virtual_network_type = var.virtual_network_type


  tags = var.tags
}
