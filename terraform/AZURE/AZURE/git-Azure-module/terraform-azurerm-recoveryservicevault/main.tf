locals {
  logs_list = ["AzureSiteRecoveryJobs", "AddonAzureBackupProtectedInstance", "AddonAzureBackupStorage", "AddonAzureBackupPolicy", "AddonAzureBackupAlerts", "AddonAzureBackupJobs", "CoreAzureBackup", "AzureBackupReport"]
  location_mapping = {
    "west.tfe.pwcinternal.com"    = "/subscriptions/c49d025d-1e9f-4157-88d9-c724d3ad59a6/resourcegroups/pzi-gxu7-p-rgp-0b21-p001/providers/microsoft.operationalinsights/workspaces/gx-zu7applop999"
    "central.tfe.pwcinternal.com" = "/subscriptions/9209f19c-0425-4a3d-85ce-8988a4a0a6f6/resourcegroups/pzi-gxeu-p-rgp-17e4-p001/providers/microsoft.operationalinsights/workspaces/gx-zweapplop999"
    "east.tfe.pwcinternal.com"    = "/subscriptions/2477531f-6332-49ab-bda7-2a5612a03e35/resourcegroups/pzi-gxse-p-rgp-d9ae-p001/providers/microsoft.operationalinsights/workspaces/gx-zseapplop999"
    "tfe.pwc.com"                 = "/subscriptions/c72daa19-9a38-4155-b2c6-9121045a0fdc/resourcegroups/pzi-gxus-p-rgp-0fb9-p001/providers/microsoft.operationalinsights/workspaces/gx-zu2applop999"
    "global.tfe.pwcinternal.com"  = "/subscriptions/c72daa19-9a38-4155-b2c6-9121045a0fdc/resourcegroups/pzi-gxus-p-rgp-0fb9-p001/providers/microsoft.operationalinsights/workspaces/gx-zu2applop999"
  }
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled
  tags                = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "monitor_diagnosics" {
  name                       = var.monitor_diagnostic_setting_name
  target_resource_id         = azurerm_recovery_services_vault.vault.id
  log_analytics_workspace_id = lookup(tomap(local.location_mapping), var.tfe_url)

  dynamic "log" {
    for_each = local.logs_list
    content {
      category = log.value
      enabled  = true
    }
  }
} 
