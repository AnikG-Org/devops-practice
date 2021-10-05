resource "azurerm_policy_definition" "policy_definition" {
  name                = var.policy_name
  management_group_id = var.management_group_id
  policy_type         = var.policy_type
  mode                = var.mode
  metadata            = <<EOF
{
  "category" : "${var.policy_category}"
}
EOF
  display_name        = var.display_name

  description    = var.description_name
  
  policy_rule = var.policy_rule

  parameters = var.policy_parameters

  lifecycle {
    ignore_changes = [
      metadata
    ]
  }

}