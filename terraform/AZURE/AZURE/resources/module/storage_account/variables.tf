variable "name" {
  description = "Name for the storage account"
}

variable "resource_group_name" {
  description = "Resource group name in which the storage account is to be created"
}

variable "location" {
  description = "The Azure region where the storage account is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}
variable "account_tier"{
    description = "Defines the Tier to use for this storage account. Valid options are Standard and Premium."
}
variable "account_replication_type"{
    description = "Defines the type of replication to use for this storage account. Valid option is LRS currently as per Azure Stack Storage Differences."
}

variable "tags" {
  description = "Map of tags to be attached"
  type        = map(string)
}

