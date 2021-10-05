resource "azurerm_log_analytics_solution" "solution_sentine_01" {
  solution_name         = var.solution_name
  location              =var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = var.workspace_resource_id
  workspace_name        = var.workspace_name
  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }

}
resource "azurerm_sentinel_alert_rule_scheduled" "schedule_01" {
  name                       = var.name
  log_analytics_workspace_id = azurerm_log_analytics_solution.solution_sentine_01.workspace_resource_id
  display_name               = var.display_name
  severity                   = var.severity
  query                      = <<QUERY
AzureActivity |
  where OperationName == "Create or Update Virtual Machine" or OperationName =="Create Deployment" |
  where ActivityStatus == "Succeeded" |
  make-series dcount(ResourceId) default=0 on EventSubmissionTimestamp in range(ago(7d), now(), 1d) by Caller
QUERY
}