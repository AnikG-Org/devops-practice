resource "azurerm_application_security_group" "asg" {
  count               = var.asg_count != 0 ? 1 : 0
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_network_interface_application_security_group_association" "nic_asg_assoc" {
  count                         = var.asg_count != 0 && var.nic_ids != null ? length(var.nic_ids) : 0
  network_interface_id          = element(var.nic_ids, count.index)
  application_security_group_id = length(local.asg_id) == 1 ? local.asg_id.id : null
}
