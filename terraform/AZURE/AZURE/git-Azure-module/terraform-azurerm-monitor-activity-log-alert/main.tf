data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_monitor_action_group" "ag" {
  resource_group_name = data.azurerm_resource_group.rg.name
  name                = var.monitor_action_group_name
}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.rg.name
  scopes              = var.scopes
  description         = var.description
  enabled             = var.enabled

  criteria {
    resource_id    = var.resource_id
    operation_name = var.operation_name
    category       = var.category
    level          = var.level
    status         = var.status
  }

  action {
    action_group_id = data.azurerm_monitor_action_group.ag.id

    webhook_properties = {
      from = "terraform"
    }
  }

  tags = var.tags
}

