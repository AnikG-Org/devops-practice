data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "key_vault" {
  name                            = var.name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  tags                            = { for k, v in var.tags: k => v if v != "" }
  sku_name                        = "premium"

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
  access_policy {
    tenant_id               = data.azurerm_client_config.current.tenant_id
    object_id               = data.azurerm_client_config.current.object_id
    secret_permissions      = []
    certificate_permissions = []
    key_permissions         = [
      "get",
      "list",
      "create",
      "update",
      "import",
      "delete",
      "recover",
      "backup",
      "restore"
    ]
  }

  access_policy {
    tenant_id               = local.thales_tenant_id
    object_id               = local.thales_object_id
    secret_permissions      = []
    certificate_permissions = []
    key_permissions         = [
      "get",
      "list",
      "create",
      "update",
      "import",
      "delete",
      "recover",
      "backup",
      "restore"
    ]
  }

  dynamic "network_acls" {
    for_each = var.network_acls
    iterator = nacl
    content {
      default_action = nacl.value.default_action
      bypass         = nacl.value.bypass
      # TF 0.12.x fixed issue with passing lists into module, no longer needed for compatibility with tf 0.12
      ip_rules                   = nacl.value.ip_rules
      virtual_network_subnet_ids = concat(local.tfe_subnets, local.env.virtual_network_subnet_ids, nacl.value.virtual_network_subnet_ids)
    }
  }
}

resource "azurerm_key_vault_key" "keys" {
  count        = length(local.keys)
  name         = var.key_suffix != "" ? "${local.keys[count.index]}-${var.key_suffix}" : local.keys[count.index]
  key_vault_id = azurerm_key_vault.key_vault.id
  key_type     = "RSA"
  key_size     = "2048"
  key_opts     = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey"
  ]

  tags = { for k, v in var.tags: k => v if v != "" }
}
