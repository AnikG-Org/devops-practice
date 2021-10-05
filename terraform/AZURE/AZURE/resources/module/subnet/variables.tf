// variable "name" {
//   description = "Rg name"
//   type        = string
// }


variable "virtual_network_name" {
  description = "virtual_network_name"
}

variable "resource_group_name" {
  description = "resource_group_name"
  type        = string
}
variable "address_prefixes" {
  description = "address_prefixes"
  type = list(string)
}


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
