resource "azurerm_policy_definition" "policy_01" {
  name         = var.name
  policy_type  = var.policy_type
  mode         = var.mode
  display_name = var.display_name

policy_rule = <<POLICY_RULE
    {
      "if": {
        "allof": [
          {
            "field": "type",
            "equals": "Microsoft.Network/networkSecurityGroups"
          },
          {
            "count": {
              "field": "Microsoft.Network/networkSecurityGroups/flowLogs[*]"
            },
            "equals": 0
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
  }
POLICY_RULE


  parameters = <<PARAMETERS
    {
      "effect": {
        "type": "String",
        "metadata": {
          "displayName": "Effect",
          "description": "Enable or disable the execution of the policy"
        },
        "allowedValues": [
          "Audit",
          "Disabled"
        ],
        "defaultValue": "Audit"
      }
  }
PARAMETERS

}


resource "azurerm_policy_assignment" "assignment_01" {
  name                 = var.assignment_name
  scope                = var.scope
  policy_definition_id = azurerm_policy_definition.policy_01.id
  description          = "The list of locations that can be specified when deploying resources."
  display_name         = var.display_name

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  parameters = <<PARAMETERS
{
  "effect": {
    "value": "Audit"
  }
}
PARAMETERS

}