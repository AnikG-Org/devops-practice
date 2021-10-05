locals {
  timemap = {
    "1M"  = "PT1M"
    "5M"  = "PT5M"
    "15M" = "PT15M"
    "30M" = "PT30M"
    "1H"  = "PT1H"
    "6H"  = "PT6H"
    "12H" = "PT12H"
    "1D"  = "P1D"
  }
}

resource "azurerm_monitor_metric_alert" "monitor_alert" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = var.scopes
  description         = var.description
  frequency           = local.timemap[var.frequency]
  window_size         = local.timemap[var.window_size]

  tags = var.tags

  action {
    action_group_id = var.action_group_id
  }

  criteria {
    metric_namespace = var.metric_namespace
    metric_name      = var.metric_name
    aggregation      = var.aggregation
    operator         = var.operator
    threshold        = var.threshold
  }
}

