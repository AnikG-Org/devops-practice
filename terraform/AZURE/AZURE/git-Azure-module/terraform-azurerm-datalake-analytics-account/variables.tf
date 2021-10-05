variable "data_lake_analytics_account_name" {
  type        = string
  description = "The name that will be used for the Data Lake Analytics account."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group to create the Data Lake Analytics account in."
}

variable "location" {
  type        = string
  description = "The Azure region where the Data Lake Analytics account is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "default_store_account_name" {
  description = "The Azure Data Lake store to use by default. Note that changing this value causes a new Data Lake Analytics account resource to be created."
  type        = string
}

variable "tier" {
  description = " The tier type of the Data Lake Analytics account to be created. Possible values: `Consumption`, `Commitment_100000AUHours`, `Commitment_10000AUHours`, `Commitment_1000AUHours`, `Commitment_100AUHours`, `Commitment_500000AUHours`, `Commitment_50000AUHours`, `Commitment_5000AUHours`, or `Commitment_500AUHours`. See https://azure.microsoft.com/en-us/pricing/details/data-lake-analytics/ for pricing details."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to be attached to the Data Lake Analytics account"
  type        = map(string)
}

