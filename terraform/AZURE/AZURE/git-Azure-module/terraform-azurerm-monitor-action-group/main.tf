resource "azurerm_monitor_action_group" "monitor-action-group" {
  name                = var.name
  resource_group_name = var.resource_group_name
  short_name          = var.short_name

  dynamic "email_receiver" {
    for_each = var.email_receivers
    content {
      email_address           = email_receiver.value.email_address
      name                    = email_receiver.value.name
      use_common_alert_schema = lookup(email_receiver.value, "use_common_alert_schema", null)
    }
  }
  tags = var.tags
}

