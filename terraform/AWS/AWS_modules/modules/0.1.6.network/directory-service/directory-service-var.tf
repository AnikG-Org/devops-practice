variable "enable_directory_service" {
  type    = bool
  default = true
}
variable "name" {
  description = "The fully qualified name for the directory, such as corp.example.com"
  type        = string
}

variable "password" {
  description = "The password for the directory administrator or connector user"
  type        = string
}

variable "size" {
  description = "(Required for SimpleAD and ADConnector) The size of the directory (Small or Large)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Subnet IDs for the directory servers/connectors (2 subnets in 2 different AZs)"
  type        = list(string)
}

variable "connect_settings" {
  description = "Connector related information about the directory (required for ADConnector)"
  type = object({
    # The username corresponding to the password provided.
    customer_username = string
    # The DNS IP addresses of the domain to connect to.
    customer_dns_ips = list(string)
  })
  default = null
}

variable "alias" {
  description = "The alias for the directory, unique amongst all aliases in AWS (required for enable_sso)"
  type        = string
  default     = null
}

variable "description" {
  description = "A textual description for the directory"
  type        = string
  default     = null
}

variable "short_name" {
  description = "The short name of the directory, such as CORP"
  type        = string
  default     = null
}

variable "enable_sso" {
  description = "Whether to enable single-sign on for the directory (requires alias)"
  default     = false
}

variable "type" {
  description = "Either SimpleAD, ADConnector or MicrosoftAD"
  type        = string
  default     = "SimpleAD"

  validation {
    condition     = contains(["SimpleAD", "ADConnector", "MicrosoftAD"], var.type)
    error_message = "`type` must be one of: \"SimpleAD\", \"ADConnector\", \"MicrosoftAD\"."
  }
}

variable "edition" {
  description = "(Required for the MicrosoftAD type only) The MicrosoftAD edition (Standard or Enterprise)."
  type        = string
  default     = null

  validation {
    condition     = var.edition != null ? contains(["Standard", "Enterprise"], var.edition) : true
    error_message = "`type` must be one of: \"Standard\", \"Enterprise\"."
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}