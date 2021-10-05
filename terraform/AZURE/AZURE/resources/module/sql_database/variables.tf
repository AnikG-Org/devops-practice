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

 
variable "server_name" {
  description = "version"

}

variable "tags" {
  description = "Map of tags to be attached to the ASG."
  type        = map(string)
}

