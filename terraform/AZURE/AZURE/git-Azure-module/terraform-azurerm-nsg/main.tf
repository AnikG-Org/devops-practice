resource "azurerm_network_security_group" "nsg" {
  count               = var.nsg_count != 0 ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  lifecycle {
    ignore_changes = [security_rule]
  }

  dynamic "security_rule" {
    for_each = var.create_default_rules ? local.single_source_single_destination : []
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }

  dynamic "security_rule" {
    for_each = var.create_default_rules ? local.single_source_multi_destination : []
    content {
      name                         = security_rule.value.name
      priority                     = security_rule.value.priority
      direction                    = security_rule.value.direction
      access                       = security_rule.value.access
      protocol                     = security_rule.value.protocol
      source_port_range            = security_rule.value.source_port_range
      destination_port_range       = security_rule.value.destination_port_range
      source_address_prefix        = security_rule.value.source_address_prefix
      destination_address_prefixes = security_rule.value.destination_address_prefixes
    }
  }

  dynamic "security_rule" {
    for_each = var.create_default_rules ? local.multi_source_single_destination : []
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefixes    = security_rule.value.source_address_prefixes
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

resource "azurerm_network_security_rule" "custom" {
  count                       = var.nsg_count != 0 && var.custom_rules != null ? length(var.custom_rules) : 0
  name                        = var.custom_rules[count.index]["name"]
  priority                    = 200+count.index
  direction                   = var.custom_rules[count.index]["direction"]
  access                      = var.custom_rules[count.index]["access"]
  protocol                    = var.custom_rules[count.index]["protocol"]
  source_port_range           = var.custom_rules[count.index]["source_port_range"]
  destination_port_range      = var.custom_rules[count.index]["destination_port_range"]
  source_address_prefix       = var.custom_rules[count.index]["source_address_prefix"]
  destination_address_prefix  = var.custom_rules[count.index]["destination_address_prefix"]
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg[0].name
}
