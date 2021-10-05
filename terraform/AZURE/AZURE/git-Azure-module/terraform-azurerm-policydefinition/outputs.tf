output "policy_id" {
  value       = "${azurerm_policy_definition.policy_definition.id}"
  description = "The id of the Azure Policy definition created."
}

