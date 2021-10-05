# Create the loadbalancer rules for given RGP ,loadbalancer & probe
resource "azurerm_lb_rule" "lb_rule" {
  count                          = length(var.lb_rule_specs)
  name                           = var.lb_rule_specs[count.index]["name"]
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = var.loadbalancer_id
  frontend_ip_configuration_name = var.lb_rule_specs[count.index]["frontend_ip_configuration_name"]
  protocol                       = var.lb_rule_specs[count.index]["protocol"]
  frontend_port                  = var.lb_rule_specs[count.index]["frontend_port"]
  backend_port                   = var.lb_rule_specs[count.index]["backend_port"]
  probe_id                       = var.probe_id
  load_distribution              = var.load_distribution
  backend_address_pool_id        = var.backend_address_pool_id
}

