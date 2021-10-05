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

resource "azurerm_key_vault" "key_vault" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_template_deployment = var.enabled_for_template_deployment
  tags                            = var.tags
  sku_name                        = var.sku_name
  purge_protection_enabled        = var.purge_protection_enabled
  # Dynamic block allows omitting the access_policy block if needed, 
  # as when specifying access policies using a dedicated resource type
  dynamic "access_policy" {
    for_each = var.access_policies
    iterator = policy
    content {
      tenant_id               = policy.value.tenant_id
      object_id               = policy.value.object_id
      key_permissions         = policy.value.key_permissions
      secret_permissions      = policy.value.secret_permissions
      certificate_permissions = policy.value.certificate_permissions
    }
  }

  
  dynamic "network_acls" {
    for_each = var.network_acls
    iterator = nacl
    content {
      default_action = nacl.value.default_action
      bypass         = nacl.value.bypass
      # TF 0.12.x fixed issue with passing lists into module, no longer needed for compatibility with tf 0.12
      ip_rules                   = concat(nacl.value.ip_rules, ["40.90.185.191", "52.137.27.226", "52.190.32.228", "62.200.104.4", "81.209.169.52", "167.14.100.1", "167.14.100.10", "155.201.0.0/24"])
      virtual_network_subnet_ids = var.tfe_hostname != null ? concat(nacl.value.virtual_network_subnet_ids, [local.tfe_subnets[local.tfe_subnet_key]]) : nacl.value.virtual_network_subnet_ids
    }
  }
}

resource "azurerm_key_vault_secret" "secrets" {
  count        = length(var.secrets)
  name         = var.secrets[count.index]["name"]
  value        = var.secrets[count.index]["value"]
  key_vault_id = azurerm_key_vault.key_vault.id

  tags = var.tags
}

