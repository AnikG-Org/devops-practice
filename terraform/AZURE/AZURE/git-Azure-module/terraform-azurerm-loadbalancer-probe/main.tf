# Create the loadbalancer probes for given RGP and loadbalancer
resource "azurerm_lb_probe" "lb_probe" {
  resource_group_name = var.resource_group_name
  loadbalancer_id     = var.loadbalancer_id
  name                = var.name
  port                = var.port
}

