variable "name" {
  description = "Rg name"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources to."
  type        = string
}

variable "tags" {
  description = "Map of tags to be attached"
  type        = map(string)
}