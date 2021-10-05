output "lb_rule_ids" {
  value = [azurerm_lb_rule.lb_rule.*.id]
}

