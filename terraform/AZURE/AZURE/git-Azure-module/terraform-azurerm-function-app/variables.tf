variable "storage_account_name" {
  description = "Name of the backend storage account used by the Function App."
  type        = string
}

variable "storage_account_access_key" {
  description = "The access key for the backend storage account used by the Function App."
  type        = string
}

variable "pre_warmed_instance_count" {
  description = "The number of pre-warmed instances for this function app. Only affects apps on the Premium plan."
  default     = null
}

variable "name" {
  description = "Name of the azure function app to be deployed."
  type        = string
}

variable "location" {
  description = "Location of the resource group in which the azure function is to be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Function App."
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan within which to create this Function App."
  type        = string
}

variable "app_service_plan_sku_tier" {
  description = "App Service Plan Tier: Standard, Basic, Premium, etc."
  type        = string
}

variable "os_type" {
  type        = string
  description = "A string indicating the Operating System type for this function app. Defaults to Windows"
  default     = null
}

variable "enable_builtin_logging" {
  type        = bool
  description = "Should the built-in logging of this Function App be enabled?"
  default     = true
}

variable "identity_type" {
  type        = string
  description = "Specifies the identity type of the Function App."
  default     = "SystemAssigned"
}

variable "identity_ids" {
  type        = list(string)
  description = "Specifies a list of user managed identity ids to be assigned."
  default     = null
}

variable "tags" {
  description = "Map of tags to be attached to the function app."
  type        = map(string)
}

variable "app_settings" {
  description = "A key-value pair of App Settings."
  type        = map(string)
  default     = {}
}

variable "function_app_version" {
  description = "The runtime version associated with the Function App."
  type        = string
  default     = "~3"
}

variable "client_affinity_enabled" {
  type        = string
  description = "Should the Function App send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}

variable "daily_memory_time_quota" {
  type        = number
  description = "The amount of memory in gigabyte-seconds that your application is allowed to consume per day. Setting this value only affects function apps under the consumption plan."
  default     = 0
}

variable "enabled" {
  type        = bool
  description = "Is the Function App enabled?"
  default     = true
}

variable "always_on" {
  type        = bool
  description = "Should the Function App be loaded at all times?"
  default     = true
}

variable "ftps_state" {
  type        = string
  description = "State of FTP / FTPS service for this function app."
  default     = "AllAllowed"
}

variable "http2_enabled" {
  type        = bool
  description = "Specifies whether or not the http2 protocol should be enabled."
  default     = false
}

variable "linux_fx_version" {
  type        = string
  description = "Linux App Framework and version for the AppService, e.g. DOCKER|(golang:latest)."
  default     = null
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the function app."
  default     = "1.2"
}

variable "use_32_bit_worker_process" {
  type        = bool
  description = "Should the Function App run in 32 bit mode, rather than 64 bit mode?"
  default     = false
}

variable "websockets_enabled" {
  type        = bool
  description = "Should WebSockets be enabled?"
  default     = false
}

variable "ip_restrictions" {
  description = "A list of ip restrictions to impose on this function app."
  type        = list(map(string))
  default     = null
}
