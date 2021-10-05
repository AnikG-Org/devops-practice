## Required Parameters ##
variable "name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources to."
  type        = string
}

variable "resource_group_name" {
  description = "The resource group name to deploy AKS cluster to."
  type        = string
}

 
// variable "version" {
//   description = "version"

// }
variable "administrator_login" {
  description = "administrator_login"
  type        = string
}
variable "administrator_login_password" {
  description = "administrator_login_password"
  type        = string
}
variable "tags" {
  description = "Map of tags to be attached to the ASG."
  type        = map(string)
}

