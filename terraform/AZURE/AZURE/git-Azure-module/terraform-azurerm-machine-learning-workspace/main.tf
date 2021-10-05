resource "azurerm_machine_learning_workspace" "mlworkspace" {
  name                    = var.mlworkspace_name
  location                = var.location
  resource_group_name     = var.resource_group_name
  application_insights_id = var.application_insights_id
  key_vault_id            = var.key_vault_id
  storage_account_id      = var.storage_account_id
  container_registry_id   = var.container_registry_id
  description             = var.description
  friendly_name           = var.friendly_name
  high_business_impact    = var.high_business_impact
  sku_name                = var.sku_name
  identity {
    type = var.identity
  }
  tags   = var.tags
}

