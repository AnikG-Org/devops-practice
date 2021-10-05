resource "azurerm_storage_account" "storage" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  account_tier              = var.account_tier
  account_replication_type  = var.account_replication_type
  account_kind              = var.account_kind
  enable_https_traffic_only = true
  tags                      = var.tags
  is_hns_enabled            = var.is_hns_enabled
  access_tier               = (var.account_kind == "Storage" || var.account_kind == "BlockBlobStorage") ? null : var.access_tier
  allow_blob_public_access  = false
  min_tls_version           = local.min_tls_version
  dynamic "static_website" {
    for_each = (var.index_document != null) ? [var.index_document] : []
    content {
      index_document = var.index_document
    }
  }
  dynamic "blob_properties" {
    for_each = (var.blob_properties != null) ? [var.blob_properties] : []
    iterator = it
    content {
      cors_rule {
        allowed_headers    = it.value["cors_rule"].allowed_headers
        allowed_methods    = it.value["cors_rule"].allowed_methods
        allowed_origins    = it.value["cors_rule"].allowed_origins
        exposed_headers    = it.value["cors_rule"].exposed_headers
        max_age_in_seconds = it.value["cors_rule"].max_age_in_seconds
      }
    }
  }
  dynamic "custom_domain" {
    for_each = (var.custom_domain != null) ? [var.custom_domain] : []
    content {
      name          = var.custom_domain.name
      use_subdomain = var.custom_domain.use_subdomain
    }
  }
}

locals {
  tfe_subnets = {
    "https://west.tfe.pwcinternal.com" : "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-PTFE-P003"

    "https://east.tfe.pwcinternal.com" : "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/pzi-gxse-gs-rgp-base-p001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-PTFE-P002"

    "https://global.tfe.pwcinternal.com" : "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-PTFE-P004"

    "https://central.tfe.pwcinternal.com" : "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-PTFE-P002"

    "https://stage.tfe.pwcinternal.com" : "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/PZI-GXUS-GS-RGP-BASE-P002/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P002/subnets/PZI-GXUS-GS-SNT-PTFE-S002"

    "https://dev.tfe.pwcinternal.com" : "/subscriptions/09fc7e82-83be-4dac-ba29-7854fe2b7704/resourceGroups/PZI-GXUS-GS-RGP-BASE-P007/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P007/subnets/PZI-GXUS-GS-SNT-PTFE-D002"

    "https://tfe.pwc.com" : "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-HTFE-P002"

    "https://tfe-dev.pwc.com" : "/subscriptions/09fc7e82-83be-4dac-ba29-7854fe2b7704/resourceGroups/PZI-GXUS-GS-RGP-BASE-P007/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P007/subnets/PZI-GXUS-G-SNT-HTFE-P001"

    "https://tfe-stage.pwc.com" : "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/PZI-GXUS-GS-RGP-BASE-P002/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P002/subnets/PZI-GXUS-GS-SNT-HTFE-P003"
  }
  tfe_subnet_key = var.tfe_hostname != null ? replace(var.tfe_hostname, "/\\/$/", "") : var.tfe_hostname
}

resource "azurerm_storage_account_network_rules" "network_rules" {
  resource_group_name  = var.resource_group_name
  storage_account_name = azurerm_storage_account.storage.name

  default_action             = var.default_action
  ip_rules                   = concat(var.ip_rules, ["40.90.185.191", "52.137.27.226", "52.190.32.228", "62.200.104.4", "81.209.169.52", "167.14.100.1", "167.14.100.10", "155.201.0.0/24"])
  virtual_network_subnet_ids = var.tfe_hostname != null ? concat(var.virtual_network_subnet_ids, [local.tfe_subnets[local.tfe_subnet_key]]) : var.virtual_network_subnet_ids
  bypass                     = var.bypass
  depends_on                 = [azurerm_storage_account.storage]
}

resource "azurerm_storage_container" "containers" {
  depends_on           = [azurerm_storage_account.storage]
  count                = length(var.containers)
  name                 = var.containers[count.index]["name"]
  storage_account_name = azurerm_storage_account.storage.name
  container_access_type = lookup(
    var.containers[count.index],
    "container_access_type",
    "private",
  )
}

resource "azurerm_advanced_threat_protection" "threat" {
  depends_on         = [azurerm_storage_account.storage]
  target_resource_id = azurerm_storage_account.storage.id
  enabled            = true
}

