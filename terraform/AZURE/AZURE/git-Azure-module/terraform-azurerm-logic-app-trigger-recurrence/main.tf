resource "azurerm_logic_app_trigger_recurrence" "trigger" {
  name         = var.name
  logic_app_id = var.logic_app_id
  frequency    = var.frequency
  interval     = var.interval
}
