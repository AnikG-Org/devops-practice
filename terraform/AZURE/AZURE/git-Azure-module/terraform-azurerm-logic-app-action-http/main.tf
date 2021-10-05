resource "azurerm_logic_app_action_http" "action-http" {
  name         = var.name
  logic_app_id = var.logic_app_id
  method       = var.method
  uri          = var.uri
}
