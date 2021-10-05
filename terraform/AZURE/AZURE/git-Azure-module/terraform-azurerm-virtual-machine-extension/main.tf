
resource "azurerm_virtual_machine_extension" "virtual_machine_extension" {
  name                       = var.name
  virtual_machine_id         = var.virtual_machine_id
  publisher                  = var.publisher
  type                       = var.type
  type_handler_version       = var.type_handler_version
  auto_upgrade_minor_version = var.auto_upgrade_minor_version

  settings = <<SETTINGS
  {
  ${var.settings}
  }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
  {
  ${var.protected_settings}
  }
PROTECTED_SETTINGS

  tags = var.tags

}

