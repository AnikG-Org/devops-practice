resource "azurerm_network_security_rule" "nsg_rules" {
  count                                      = length(var.rules)
  resource_group_name                        = var.resource_group_name
  network_security_group_name                = var.network_security_group_name
  name                                       = var.rules[count.index].name
  priority                                   = 200+count.index
  direction                                  = var.rules[count.index].direction
  access                                     = var.rules[count.index].access
  protocol                                   = var.rules[count.index].protocol
  description                                = var.rules[count.index].name
  source_port_range                          = length(split(",", lookup(var.rules[count.index], "source_ports"))) == 1 ? lookup(var.rules[count.index], "source_ports") : null
  source_port_ranges                         = length(split(",", lookup(var.rules[count.index], "source_ports"))) > 1 ? split(",", lookup(var.rules[count.index], "source_ports")) : null
  destination_port_range                     = length(split(",", lookup(var.rules[count.index], "destination_ports"))) == 1 ? lookup(var.rules[count.index], "destination_ports") : null
  destination_port_ranges                    = length(split(",", lookup(var.rules[count.index], "destination_ports"))) > 1 ? split(",", lookup(var.rules[count.index], "destination_ports")) : null
  source_address_prefix                      = replace(lookup(var.rules[count.index], "source"), "subscriptions", "") == lookup(var.rules[count.index], "source") && length(split(",", lookup(var.rules[count.index], "source"))) == 1 ? lookup(var.rules[count.index], "source") : null
  source_address_prefixes                    = replace(lookup(var.rules[count.index], "source"), "subscriptions", "") == lookup(var.rules[count.index], "source") && length(split(",", lookup(var.rules[count.index], "source"))) > 1 ? split(",", lookup(var.rules[count.index], "source")) : null
  source_application_security_group_ids      = replace(lookup(var.rules[count.index], "source"), "subscriptions", "") != lookup(var.rules[count.index], "source") ? split(",", lookup(var.rules[count.index], "source")) : null
  destination_address_prefix                 = replace(lookup(var.rules[count.index], "destination"), "subscriptions", "") == lookup(var.rules[count.index], "destination") && length(split(",", lookup(var.rules[count.index], "destination"))) == 1 ? lookup(var.rules[count.index], "destination") : null
  destination_address_prefixes               = replace(lookup(var.rules[count.index], "destination"), "subscriptions", "") == lookup(var.rules[count.index], "destination") && length(split(",", lookup(var.rules[count.index], "destination"))) > 1 ? split(",", lookup(var.rules[count.index], "destination")) : null
  destination_application_security_group_ids = replace(lookup(var.rules[count.index], "destination"), "subscriptions", "") != lookup(var.rules[count.index], "destination") ? split(",", lookup(var.rules[count.index], "destination")) : null
}