data "azurerm_key_vault" "keyvault" {
  name                = var.user_parameters.naming_service.key_vault.k01
  resource_group_name = var.__ghs.environment_resource_groups
}

data "azurerm_client_config" "current" {}

module "primary_keyvault_spn_access_policy" {
  source                  = "../../"
  key_vault_id            = data.azurerm_key_vault.keyvault.id
  tenant_id               = data.azurerm_client_config.current.tenant_id
  object_ids              = [data.azurerm_client_config.current.object_id]
  key_permissions         = ["get", "create", "list", "update", "delete"]
  secret_permissions      = ["get", "set", "list", "delete"]
  certificate_permissions = ["get", "create", "list", "update", "delete"]
}
