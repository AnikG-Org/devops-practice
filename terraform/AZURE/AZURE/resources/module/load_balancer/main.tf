resource "azurerm_lb" "loadbalancer" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags = var.tags
  frontend_ip_configuration {
    name                 = var.ip_name_01
    public_ip_address_id = var.public_ip_address_id
  }
}