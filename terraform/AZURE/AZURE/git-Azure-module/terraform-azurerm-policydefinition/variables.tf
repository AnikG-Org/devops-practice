variable "policy_name" {
  description = "The name of the policy definition"
  type        = string
}

variable "management_group_id" {
  description = "The ID of the Management Group where this policy should be defined. Changing this forces a new resource to be created. Leaving this blank will define the policy in the Azure Subscription Terraform is authenticated to."
  type        = string
}

variable "mode" {
  description = "The policy mode. Either `All` or `Indexed`"
  type        = string
}
variable "description_name" {
  description = "The description name of the policy definition."
  type          = string
}
variable "display_name" {
  description = "The display name of the policy definition."
  type        = string
}

variable "policy_rule" {
  description = "The file containing the policy rule. E.g. `../policies/tf-ghs-enforce-general-naming-prefix-az-04/azurepolicy.rules.json`"
  type        = string
}

variable "policy_parameters" {
  description = "The file containing the policy parameters. E.g. `../policies/tf-ghs-enforce-general-naming-prefix-az-04/azurepolicy.parameters.json`"
  type        = string
}

variable "policy_category" {
  description = "The category of control for the policy. E.g. `Compute`, `Data Security`, `Network`. Defaults to `General`"
  default     = "General"
  type        = string
}

variable "policy_type" {
  description = "The policy type. The value can be `BuiltIn`, `Custom` or `NotSpecified`. Changing this forces a new resource to be created. Defaults to `Custom`"
  default     = "Custom"
  type        = string
}
