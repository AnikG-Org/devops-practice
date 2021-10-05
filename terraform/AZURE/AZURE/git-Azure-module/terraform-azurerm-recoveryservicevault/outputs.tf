output "recovery_services_vault_id" {
  value       = azurerm_recovery_services_vault.vault.id
  description = "The ID of the Recovery Services Vault created."
}

output "recovery_services_vault_name" {
  value       = azurerm_recovery_services_vault.vault.name
  description = "The Name of the Recovery Services Vault created."
}

output "monitor_diagnostic_id" {
  value       = azurerm_monitor_diagnostic_setting.monitor_diagnosics.id
  description = "The ID of the Diagnostic Setting"
}
