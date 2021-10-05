variable "resource_group_name" {
  description = "Resource group name to place the resource."
  type        = string
}

variable "name" {
  description = "The name of the API Management."
  type        = string
}

variable "location" {
  description = "The location of the resource group."
  type        = string
}
variable "publisher_name" {
  description = "The name of the publisher."
  type        = string
}
variable "publisher_email" {
  description = "The email of the publisher."
  type        = string
}
variable "sku_name" {
  description = "The name of the SKU."
  type        = string
}
variable "tags" {
  description = "The tags associated to the resource."
  type        = map(string)
}

variable "certificates" {
  description = "Certificates to associate to this api management resource."
  type = list(object({
    b64_pfx_cert_data    = string,
    certificate_password = string,
    store_name           = string
  }))
  default = null
}

variable "identity" {
  description = "Identity block config"
  type = list(object({
    type = string,
    ids  = list(string)
  }))
  default = []
}

variable "hostname_config" {
  description = "Hostname configuration object"
  type = object({
    management = map(string),
    portal     = map(string),
    dev_portal = map(string),
    scm        = map(string),
    proxy      = map(string)
  })
  default = null
}

variable "virtual_network_type" {
  description = "The type of virtual network you want to use, valid values include: None, External, Internal"
  type        = string
  default     = "Internal"
}

variable "subnet_id" {
  description = "Subnet ID for the API Management Service to use."
  type        = string
  default     = null
}
