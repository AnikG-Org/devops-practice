resource "azurerm_network_interface_application_security_group_association" "assocation" {
  count                         = var.nic_count
  network_interface_id          = var.nic_ids[count.index]
  application_security_group_id = var.application_security_group_id
}
