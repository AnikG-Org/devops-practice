resource "azurerm_key_vault_access_policy" "access_policy" {
  count                   = length(local.object_ids)
  key_vault_id            = var.key_vault_id
  tenant_id               = var.tenant_id
  object_id               = local.object_ids[count.index]
  key_permissions         = local.key_permissions
  secret_permissions      = local.secret_permissions
  certificate_permissions = local.certificate_permissions
  storage_permissions     = local.storage_permissions
}
