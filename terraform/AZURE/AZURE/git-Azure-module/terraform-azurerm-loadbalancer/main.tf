###  Load balancer creation  ###

resource "azurerm_lb" "lb" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku

  frontend_ip_configuration {
    name                          = var.lb_frontend_ip_configuration_name
    subnet_id                     = var.lb_frontend_ip_configuration_subnet_id
    private_ip_address            = var.private_ip_address
    private_ip_address_allocation = var.private_ip_address_allocation
    public_ip_address_id          = var.public_ip_address_id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "lb_backend_address_pool" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "${azurerm_lb.lb.name}-BackEndAddressPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "attach_lb_nic" {
  count                   = length(var.vm_nics)

  network_interface_id    = var.vm_nics[count.index].nic_id
  ip_configuration_name   = var.vm_nics[count.index].ip_config_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
}

resource "azurerm_lb_nat_rule" "lb_nat" {
  count = length(var.lb_nat_rules)

  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lb-nat-rule-${count.index}"
  protocol                       = var.lb_ports[count.index].protocol
  frontend_port                  = var.lb_ports[count.index].frontend_port
  backend_port                   = var.lb_ports[count.index].backend_port
  frontend_ip_configuration_name = var.lb_frontend_ip_configuration_name
}

resource "azurerm_lb_probe" "lb_probe" {
  count               = length(var.lb_probe_ports)

  resource_group_name = var.resource_group_name
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "lb-probe-rule-${count.index}"
  protocol            = var.lb_probe_ports[count.index].protocol
  port                = var.lb_probe_ports[count.index].backend_port
  request_path        = try(var.lb_ports[count.index].request_path, null)
  interval_in_seconds = var.lb_probe_interval
  number_of_probes    = var.lb_probe_unhealthy_threshold
}

# Reference subscription ID to interpolate probe IDs later
data "azurerm_subscription" "current" {}

resource "azurerm_lb_rule" "lb_rule" {
  count                          = length(var.lb_ports)

  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lb-rule-${var.lb_ports[count.index].protocol}-${var.lb_ports[count.index].frontend_port}-to-${var.lb_ports[count.index].backend_port}"
  protocol                       = var.lb_ports[count.index].protocol
  frontend_port                  = var.lb_ports[count.index].frontend_port
  backend_port                   = var.lb_ports[count.index].backend_port
  frontend_ip_configuration_name = var.lb_frontend_ip_configuration_name
  enable_floating_ip             = var.enable_floating_ip
  backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_backend_address_pool.id
  idle_timeout_in_minutes        = var.idle_timeout_minutes
  load_distribution              = var.load_distribution
  probe_id                       = ((var.lb_ports[count.index].has_probe != false)
                                    ? "/subscriptions/${data.azurerm_subscription.current.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/loadBalancers/${azurerm_lb.lb.name}/probes/${azurerm_lb_probe.lb_probe[count.index].name}"
                                    : null)

  depends_on                     = [azurerm_lb_probe.lb_probe]
}