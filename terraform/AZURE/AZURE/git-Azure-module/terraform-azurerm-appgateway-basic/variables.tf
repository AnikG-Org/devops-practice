variable "name" {
  description = "Name for azure application gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name in which the application gateway is to be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the Application Gateway is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
}

variable "sku_name" {
  description = "The Name of the SKU to use for this Application Gateway. Possible values are Standard_Small, Standard_Medium, Standard_Large, Standard_v2, WAF_Medium, WAF_Large, and WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "tier" {
  description = "The Tier of the SKU to use for this Application Gateway. Possible values are Standard, Standard_v2, WAF and WAF_v2."
  type        = string
  default     = "Standard_v2"
}

variable "sku_capacity" {
  description = "SKU capacity for application gateway"
  type        = string
}

variable "frontend_ports" {
  description = "Frontend Ports Configurations"
  type = list(object({
    name = string
    port = number
    }
  ))
}

variable "backend_address_pools" {
  description = "Backend Address Pool Configurations"
  type = list(object({
    name         = string
    ip_addresses = list(string)
    fqdns        = list(string)
    }
  ))
}

variable "auth_cert" {
  description = "Authentication Certificate Configurations"
  type = list(object({
    authentication_certificate_name = string
    authentication_certificate_data = string
    }
  ))
}

variable "backend_http_settings" {
  description = "Backend HTTP Configurations"
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    backend_http_port                   = number
    backend_http_protocol               = string
    backend_request_timeout_in_seconds  = number
    host_name                           = string
    probe_name                          = string
    pick_host_name_from_backend_address = bool
    }
  ))
}

variable "routing_rule" {
  description = "Routing Rules"
  type = list(object({
    name                       = string
    http_listener_name         = string
    backend_address_pool_name  = string
    backend_http_settings_name = string
    url_path_map_name          = string
    }
  ))
}

variable "listener" {
  description = "HTTP Listener Configurations"
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = string
    host_name                      = string
  }))
}

variable "subnet_id" {
  description = "Subnet ID in which application gateway must be created."
  type        = string
}

variable "match" {
  description = "The blocks of match code"
  type = list(object({
    healthprobe_match_response_body = list(string)
    healthprobe_match_statuscodes   = list(string)
  }))
  default = []
}

variable "ssl_certificates" {
  description = "SSL Certicate Configurations"
  type = list(object({
    ssl_name     = string
    data         = string
    ssl_password = string
  }))
}

variable "private_ip_address_allocation" {
  description = "Private IP address allocation (Static/Dynamic)"
  type        = string
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "The Private IP Address to use for the Application Gateway"
  type        = string
}

variable "probe" {
  description = "Probe Settings"
  type = list(object({
    name                                      = string
    protocol                                  = string
    path                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    port                                      = number
    pick_host_name_from_backend_http_settings = bool
    body                                      = string
    status_code                               = list(string)
    }
  ))
  default = []
}

variable "url_path_map" {
  type = list(object({
    name : string
    default_backend_http_settings_name : string
    default_backend_address_pool_name : string
    default_redirect_configuration_name : string
    path_rule : list(object({
      path_rule_name : string
      paths : list(string)
      backend_address_pool_name : string
      backend_http_settings_name : string
    }))
  }))
  default = []
}

variable "tags" {
  description = "Tags to be attached to application gateway"
  type        = map
}


