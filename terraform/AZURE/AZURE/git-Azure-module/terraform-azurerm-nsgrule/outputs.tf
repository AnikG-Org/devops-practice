output "ids" {
  value = azurerm_network_security_rule.nsg_rules.*.id
}
