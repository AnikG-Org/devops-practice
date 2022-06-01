resource "azurerm_resource_group" "example" {
  name     = "workflow-resources"
  location = "West Europe"
}

resource "azurerm_logic_app_workflow" "example" {
  name                = "workflow1"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_logic_app_trigger_recurrence" "example" {
  name         = "run-every-day"
  logic_app_id = azurerm_logic_app_workflow.example.id
  frequency    = "Day"
  interval     = 1
  schedule {
    at_these_hours             = [02]
    at_these_minutes           = [00]
    on_these_days              = [
      "Monday",
      "Tuesday", 
      "Wednesday", 
      "Thursday", 
      "Friday",
    ]
  }
}

# resource "azurerm_logic_app_trigger_custom" "example" {
#   name         = "example-trigger"
#   logic_app_id = azurerm_logic_app_workflow.example.id

#   body = var.body
# }
# variable "body" {
#   description = ""
#   type        = string
#   default     = ""
# }
#----
#   body = <<BODY
# {
#   "recurrence": {
#     "frequency": "Day",
#     "interval": 1
#     "schedule" {
#       "at_these_hours": [02] 
#       "at_these_minutes": [00]
#     }
#   },
#   "type": "Recurrence"
# }
# BODY
#----

resource "azurerm_template_deployment" "terraform-arm" {
  name                = "terraform-arm-01"
  resource_group_name = azurerm_resource_group.terraform-arm.name
  depends_on = [azurerm_logic_app_workflow.example]
  template_body = file("template.json")

  parameters = {
    # "storageAccountName" = "terraformarm"
    # "storageAccountType" = "Standard_LRS"

  }

  deployment_mode = "Incremental"
}