
###  Mandatory input variables  ###
variable "org" {
  description = "Map of common naming organisation on the subscription"
  type        = string
}

variable "bu_code" {
  description = "Map of common naming codes based on the subscription"
  type        = string
}

variable "component" {
  description = "Application code (4 character code)"
}

variable "app_env_code" {
  description = "The application environment code (1 character)"
}

variable "sequence_no" {
  description = "The sequence number (3-digit) for the Azure object (e.g. 001,002)"
}