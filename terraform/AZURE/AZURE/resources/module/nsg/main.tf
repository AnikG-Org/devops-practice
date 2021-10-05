resource "azurerm_network_security_group" "nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  # lifecycle {
  #   ignore_changes = [security_rule]
  }

resource "azurerm_network_security_rule" "custom" {
  count                       = var.nsg_count != 0 && var.custom_rules != null ? length(var.custom_rules) : 0
  name                        = var.custom_rules[count.index]["name"]
  priority                    = var.custom_rules[count.index]["priority"]
  direction                   = var.custom_rules[count.index]["direction"]
  access                      = var.custom_rules[count.index]["access"]
  protocol                    = var.custom_rules[count.index]["protocol"]
  source_port_range           = var.custom_rules[count.index]["source_port_range"]
  destination_port_ranges      = var.custom_rules[count.index]["destination_port_ranges"]
  source_address_prefixes       = var.custom_rules[count.index]["source_address_prefixes"]
  destination_address_prefixes  = var.custom_rules[count.index]["destination_address_prefixes"]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg.name
}
