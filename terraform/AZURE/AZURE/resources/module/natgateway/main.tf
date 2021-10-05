resource "azurerm_nat_gateway" "nat_gateway" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet_nat_gateway_association" "nat_gateway_association" {
  subnet_id      = var.subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat_gateway.id
}