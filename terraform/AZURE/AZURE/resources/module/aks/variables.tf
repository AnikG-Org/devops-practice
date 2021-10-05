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

variable "dns_prefix" {
  description = "The DNS prefix to be used by cluster."
  type        = string
}
variable "default_node_pool_name" {
  description = "The name which should be used for the default Kubernetes Node Pool"
  type        = string
}
variable "node_count" {
  description = "The initial number of nodes which should exist in this Node Pool. If specified this must be between 1 and 100"
  type        = string
}
variable "vm_size" {
  description = "The size of the Virtual Machine."
  type        = string
}
variable "client_secret" {
  description = "The client secret of the SPN to be used with AKS."
  type        = string
}
variable "client_id" {
  description = "The client secret of the SPN to be used with AKS."
  type        = string
}
## Optional Parameters ##

#  variable "oms_agent" {
#    description = "Determines whether to enable the OMS agent or not. Default value is false."
#    type        = string
#    default     = false
#  }

#  variable "log_analytics_workspace_id" {
#    description = "The log analytics workspace id to be used when enabling the OMS agent."
#    type        = string
#    default     = ""
#  }
variable "tags" {
  description = "Map of tags to be attached to the ASG."
  type        = map(string)
}

