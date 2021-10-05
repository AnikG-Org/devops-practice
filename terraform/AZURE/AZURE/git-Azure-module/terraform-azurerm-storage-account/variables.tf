locals {
  min_tls_version = (contains(["TLS1_2"], var.min_tls_version)) ? var.min_tls_version : "TLS1_2"
}

variable "name" {
  type        = string
  description = "Name of storage account to be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the storage account is to be created."
}

variable "account_tier" {
  description = "Define the storage account tier (Standard or Premium)."
  type        = string
  default     = "Standard"
}

variable "account_kind" {
  description = "Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2"
  type        = string
  default     = "StorageV2"
}

variable "account_replication_type" {
  description = "Define the type of replication used for this storage account."
  type        = string
  default     = "LRS"
}

variable "containers" {
  description = "Optional list of map of container details to be created within the storage account."
  type = list(object({
    name = string
    }
  ))
  default = []
}

variable "tags" {
  description = "Map of tags to be attached to the resource group."
  type        = map(string)
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions."
  type        = string
}

variable "is_hns_enabled" {
  description = "Hierarchical Namespace to be enabled."
  type        = bool
  default     = false
}

variable "access_tier" {
  description = "Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot."
  type        = string
  default     = "Hot"
}

variable "ip_rules" {
  description = "List of public IP or IP ranges in CIDR Format. Only IPV4 addresses are allowed."
  type        = list(string)
  default     = []
}

variable "bypass" {
  description = "Specifies whether traffic is bypassed for Logging/Metrics/AzureServices. Valid options are any combination of Logging, Metrics, AzureServices, or None."
  type        = list(string)
  default     = []
}

variable "virtual_network_subnet_ids" {
  description = "A list of resource ids for subnets."
  type        = list(string)
  default     = []
}

variable "min_tls_version" {
  description = "The minimum tls version should be TLS 1.2."
  type        = string
  default     = "TLS1_2"
}

variable "default_action" {
  description = "Specifies the default action of allow or deny when no other rules match. Valid options are Deny or Allow."
  type        = string
  default     = "Deny"
}

variable "index_document" {
  description = "The webpage that Azure Storage serves for requests to the root of a website or any subfolder. For example, index.html. The value is case-sensitive."
  type        = string
  default     = null
}

variable "tfe_hostname" {
  description = "NGC TFE Instance e.g. https://example.tfe.pwcinternal.com"
  type        = string
  default     = null
}

variable "blob_properties" {
  description = "Properties for blob storage"
  type = object({
    cors_rule = object({
      allowed_headers    = list(string),
      allowed_methods    = list(string),
      allowed_origins    = list(string),
      exposed_headers    = list(string),
      max_age_in_seconds = number
    })
  })
  default = null
}

variable "custom_domain" {
  description = "The custom domain to use for the Storage Account"
  type = object({
    name          = string
    use_subdomain = bool
  })
  default = null
}
