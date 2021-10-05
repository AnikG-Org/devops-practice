variable "mlworkspace_name" {
  description = "The name of the Machine Learning Workspace."
  type        = string
}

variable "location" {
  description = "The supported Azure location where the Machine Learning Workspace should exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group in which the Machine Learning Workspace should exist."
  type        = string
}

variable "application_insights_id" {
  description = "The ID of the Application Insights associated with this Machine Learning Workspace."
  type        = string
}

variable "key_vault_id" {
  description = "The ID of key vault associated with this Machine Learning Workspace."
  type        = string
}

variable "storage_account_id" {
  description = "The ID of the Storage Account associated with this Machine Learning Workspace."
  type        = string
 }

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "container_registry_id" {
  description = "The ID of the container registry associated with this Machine Learning Workspace."
  type        = string
  default     = null
  }

variable "identity" {
  description = "The Type of Identity which should be used for this Disk Encryption Set. At this time the only possible value is SystemAssigned."
  type        = string
  default     = "SystemAssigned"
 }

variable "description" {
  description = "The description of this Machine Learning Workspace."
  type        = string
  default     = ""
 }

variable "friendly_name" {
  description = "Friendly name for this Machine Learning Workspace."
  type        = string
  default     = null
 }

variable "high_business_impact" {
  description = "Flag to signal High Business Impact (HBI) data in the workspace and reduce diagnostic data collected by the service"
  type        = string
  default     = null
 }

variable "sku_name" {
  description = "SKU/edition of the Machine Learning Workspace, possible values are Basic. Defaults to Basic."
  type        = string
  default     = null
 }
