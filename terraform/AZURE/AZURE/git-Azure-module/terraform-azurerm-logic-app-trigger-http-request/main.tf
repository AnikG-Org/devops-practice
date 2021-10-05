data "local_file" "schema" {
  filename = "${var.filename}"
}

resource "azurerm_logic_app_trigger_http_request" "trigger-http-request" {
  name         = var.name
  logic_app_id = var.logic_app_id
  schema       = data.local_file.schema.content
}
