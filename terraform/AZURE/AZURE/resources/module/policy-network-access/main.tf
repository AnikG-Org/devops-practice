resource "azurerm_policy_definition" "policy_01" {
  name         = var.name
  policy_type  = var.policy_type
  mode         = var.mode
  display_name = var.display_name

policy_rule = <<POLICY_RULE
    {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Storage/storageAccounts"
          },
          {
            "field": "Microsoft.Storage/storageAccounts/networkAcls.defaultAction",
            "notEquals": "Deny"
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
          "description": "The effect determines what happens when the policy rule is evaluated to match"
        },
        "allowedValues": [
          "Audit",
          "Deny",
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
  description          = "The effect determines what happens when the policy rule is evaluated to match"
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
