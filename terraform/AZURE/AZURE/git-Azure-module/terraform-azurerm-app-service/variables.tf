variable "name" {
  description = "Name of the azure app service to be deployed."
  type        = string
}

variable "location" {
  description = "Location of the resource group in which the azure app service is to be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the App service."
  type        = string
}

variable "app_service_plan_id" {
  description = "The ID of the App Service Plan within which to create this App service."
  type        = string
}

variable "client_cert_enabled" {
  type        = bool
  description = "Does the App Service require client certificates for incoming requests?"
  default     = false
}

variable "identity_type" {
  type        = string
  description = "Specifies the identity type of the App service."
  default     = "SystemAssigned"
}

variable "identity_ids" {
  type        = list(string)
  description = "Specifies a list of user managed identity ids to be assigned."
  default     = null
}

variable "tags" {
  description = "Map of tags to be attached to the app service."
  type        = map(string)
}

variable "app_settings" {
  description = "A key-value pair of App Settings."
  type        = map(string)
  default     = {}
}

variable "client_affinity_enabled" {
  type        = string
  description = "Should the App service send session affinity cookies, which route client requests in the same session to the same instance?"
  default     = false
}

variable "enabled" {
  type        = bool
  description = "Is the App service enabled?"
  default     = true
}

variable "always_on" {
  type        = bool
  description = "Should the App service be loaded at all times?"
  default     = true
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

variable "windows_fx_version" {
  type        = string
  description = "The Windows Docker container image (DOCKER|<user/image:tag>)"
  default     = null
}

variable "app_command_line" {
  type        = string
  description = "App command line to launch, e.g. /sbin/myserver -b 0.0.0.0."
  default     = null
}

variable "min_tls_version" {
  type        = string
  description = "The minimum supported TLS version for the app service."
  default     = "1.2"
}

variable "scm_type" {
  type        = string
  description = "The type of Source Control used by the App service."
  default     = "None"
}

variable "use_32_bit_worker_process" {
  type        = bool
  description = "Should the App service run in 32 bit mode, rather than 64 bit mode?"
  default     = false
}

variable "remote_debugging_enabled" {
  type        = bool
  description = "Is Remote Debugging Enabled?"
  default     = false
}

variable "managed_pipeline_mode" {
  type        = string
  description = "The Managed Pipeline Mode."
  default     = "Integrated"
}

variable "websockets_enabled" {
  type        = bool
  description = "Should WebSockets be enabled?"
  default     = false
}

variable "ftps_state" {
  type        = string
  description = "State of FTP / FTPS service for this function app."
  default     = "AllAllowed"
}

variable "ip_restrictions" {
  description = "A list of ip restrictions to impose on this app service"
  type        = list(map(string))
  default     = null
}

variable "dotnet_framework_version" {
  description = "The version of the .net framework's CLR used in this App Service."
  type        = string
  default     = "v4.0"
}

variable "java_version" {
  description = "The version of Java to use. If specified java_container and java_container_version must also be specified."
  type        = string
  default     = null
}

variable "java_container" {
  description = "The Java Container to use. If specified java_version and java_container_version must also be specified."
  type        = string
  default     = null
}

variable "java_container_version" {
  description = "The version of the Java Container to use. If specified java_version and java_container must also be specified."
  type        = string
  default     = null
}

variable "local_mysql_enabled" {
  description = "Is MySQL In App Enabled? This runs a local MySQL instance with your app and shares resources from the App Service plan."
  type        = bool
  default     = null
}

variable "php_version" {
  description = "The version of PHP to use in this App Service."
  type        = string
  default     = null
}

variable "python_version" {
  description = "The version of Python to use in this App Service."
  type        = string
  default     = null
}

variable "default_documents" {
  type        = list(string)
  description = "The ordering of default documents to load, if an address isn't specified."
  default     = null
}

variable "custom_domains" {
  type        = list(string)
  description = "The custom hostname to use for the App Service"
  default     = []
}

variable "custom_certificates" {
  description = "Certificate Settings"
  type = list(object({
    name      = string
    pfx_blob  = string
    password  = string
    ssl_state = string # IpBasedEnabled and SniEnabled
  }))

  default = []
}

variable "custom_managed_domains" {
  type        = list(string)
  description = "The hostname to use for the App Service with azure managed certificate"
  default     = []
}

variable "custom_no_cert_domains" {
  type        = list(string)
  description = "The hostname to use for the App Service without SSL certificate"
  default     = []
}

variable "storage" {
  description = "Configuration options for storage."
  type = list(object({
    storage_name               = string,
    storage_share_name         = string,
    storage_mount_path         = string,
    storage_account_name       = string,
    storage_account_type       = string,
    storage_account_access_key = string
    }
  ))
  default = []
}

variable "health_check_path" {
  description = "The health check path to be pinged by App Service."
  type        = string
  default     = null
}

variable "cors" {
  description = "A list of CORS to impose on this app service"
  type = list(object({
    allowed_origins     = list(string),
    support_credentials = bool
  }))
  default = null
}