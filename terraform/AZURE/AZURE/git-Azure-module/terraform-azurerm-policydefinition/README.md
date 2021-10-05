# PwC Azure Policy Definitoin

This module deploys an Azure Policy definition. 

These types of resources are supported:

* [azurerm_policy_definition](https://www.terraform.io/docs/providers/azurerm/r/policy_definition.html)

## Release Notes

* [Change Log](/changelog.md)

## Usage
```hcl
provider "azurerm" {
  version = "=2.0.0"
  features {}
}

data "azurerm_management_group" "definition_mgmt_group" {
  group_id = "MG-02-0021"
}

module "ngc-001" {
  source = "tfe-dev.pwc.com/NIS/policydefinition/azurerm"
  policy_name = "ngc-001"
  management_group_id = "${data.azurerm_management_group.definition_mgmt_group.group_id}"
  mode = "Indexed"
  display_name = "ngc-001"
  policy_rule = "${file("./policies/ngc-001/azurepolicy.rules.json")}"
  policy_parameters = "${file("./policies/ngc-001/azurepolicy.parameters.json")}"
  policy_category = "General"
  policy_type = "Custom"
}
```
## Conditional creation

## Terraform version

This module is tested on Terraform v0.12.0

## AzureRM version

This module is tested with AzureRM v2.0.0

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| policy_name | The name of the policy definition | string |  | yes |
| management_group_id | The ID of the Management Group where this policy should be defined. Changing this forces a new resource to be created. Leaving this blank will define the policy in the Azure Subscription Terraform is authenticated to. | string |  | no |
| mode | The policy mode. Either `All` or `Indexed` | string |  | yes |
| display_name | The display name of the policy definition. | string |  | yes |
| policy_rule | The file containing the policy rule. E.g. `${file(../policies/tf-ghs-enforce-general-naming-prefix-az-04/azurepolicy.rules.json)}` | string |  | yes |
| policy_parameters | The file containing the policy parameters. E.g. `${file(../policies/tf-ghs-enforce-general-naming-prefix-az-04/azurepolicy.parameters.json)}` | string |  | yes |
| policy_category | The category of control for the policy. E.g. `Compute`, `Data Security`, `Network`. | string | `General` | yes |
| policy_type | The policy type. The value can be `BuiltIn`, `Custom` or `NotSpecified`. Changing this forces a new resource to be created. | string | `Custom` | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy_id | The id of the Azure Policy definition created. |

## Tests

## Contributing

Use Terraform module crowdsourcing framework and guidance on [terraform module development](https://drive.google.com/file/d/1Aa6z0-Drg4HBrN9BimSeNKr4DK7GEojY/view)

## Authors

[Kyle M. Koppe](https://github.pwc.com/kyle-k-koppe) 

## License


