//Variables for referencing TFE Environment and Organization
variable "tfe_organization" {
  description = "The TFE organization to apply your changes to."
  default     = "example_corp"
}

//Variables for defining Policy enforcement levels. 
variable "policy_level_1" {
  description = "Enforcement level of Level 1 policies"
  default = "advisory"
}

variable "policy_level_2" {
  description = "Enforcement level of Level 2 policies"
  default = "soft-mandatory"
}

variable "policy_level_3" {
  description = "Enforcement level of Level 2 policies"
  default = "hard-mandatory"
}