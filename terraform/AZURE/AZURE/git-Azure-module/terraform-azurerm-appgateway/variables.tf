# Mandatory variables

variable "tags" {
  description = "Map of tags to be attached to the app service."
  type        = map(string)
}


variable "name" {
  description = "Name for azure application gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name in which the application gateway is to be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the ASG is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
}

variable "sku" {
  type = object({
    name : string
    tier : string
    capacity : number
  })
}

variable "subnet_id" {
  description = "Subnet ID in which application gateway must be created."
}

variable "frontend_port" {
  description = "Frontend port number for application gateway"
  type        = list(number)
}

variable "http_listener" {
  type = list(object({
    name : string
    frontend_ip_configuration_name : string
    port : number
    host_name : string
    host_names : list(string)
    protocol : string
    require_sni : bool
    ssl_certificate_name : string
    custom_error_configuration : list(object({
      status_code : string
      custom_error_page_url : string
    }))
  }))
}

variable "frontend_ip_configuration" {
  type = list(object({
    name : string
    subnet_id : string
    private_ip_address : string
    private_ip_address_allocation : string
  }))
}

variable "backend_address_pool" {
  type = list(object({
    name : string
    ip_addresses : list(string)
    fqdns : list(string)
  }))
}

variable "backend_http_settings" {
  type = list(object({
    name : string
    cookie_based_affinity : string
    affinity_cookie_name : string
    path : string
    port : number
    protocol : string
    request_timeout : number
    host_name : string
    probe_name : string
    pick_host_name_from_backend_address : bool
    trusted_root_certificate_names : list(string)
    authentication_certificate : list(string)

    connection_draining : list(object({
      enabled : bool
      drain_timeout_sec : number
    }))
  }))
}


variable "url_path_map" {
  type = list(object({
    name : string
    default_backend_http_settings_name : string
    default_backend_address_pool_name : string
    path_rule : list(object({
      name : string
      paths : list(string)
      backend_address_pool_name : string
      backend_http_settings_name : string
      redirect_configuration_name : string
      rewrite_rule_set_name : string
    }))
  }))
  default = []
}

variable "request_routing_rule" {
  type = list(object({
    name : string
    rule_type : string
    http_listener_name : string
    backend_address_pool_name : string
    backend_http_settings_name : string
    url_path_map_name : string
  }))
}

variable "probe" {
  type = list(object({
    name : string
    host : string
    port : number
    protocol : string
    path : string
    interval : number
    timeout : number
    unhealthy_threshold : number
    pick_host_name_from_backend_http_settings : bool
    minimum_servers : number

    match : list(object({
      body : string
      status_code : list(number)
    }))
  }))
  default = []
}

variable "ssl_certificate" {
  type = list(object({
    name : string
    file_name : string
    password : string
    key_vault_secret_id : string
  }))
  default = []
}

variable "nsg" {
  type = object({
    name : string
    priority_inbound_prefix : number
    priority_outbound_prefix : number

  })
  default = {
    name : "change_me"
    priority_inbound_prefix : 27
    priority_outbound_prefix : 30

  }
}

variable "ssl_policy" {
  type = list(object({
    disabled_protocols : list(string)
    policy_type : string
    cipher_suites : list(string)
    min_protocol_version : string
  }))
  default = []
}

variable "rewrite_rule_set" {
  type = list(object({
    name : string
    rewrite_rule : list(object({
      name : string
      rule_sequence : number

      condition : list(object({
        variable : string
        pattern : string
        ignore_case : bool
        negate : bool
      }))

      request_header_configuration : list(object({
        header_name : string
        header_value = string
      }))

      response_header_configuration : list(object({
        header_name : string
        header_value : string
      }))

      url : list(object({
        path : string
        query_string : string
        reroute : bool
      }))
    }))
  }))
  default = []
}

variable "redirect_configuration" {
  type = list(object({
    name : string
    redirect_type : string

    target_listener_name : string

    target_url : string

    include_path : string

    include_query_string : string
  }))
  default = []
}

variable "autoscale_configuration" {
  type = list(object({

    min_capacity : number

    max_capacity : number
  }))
  default = []
}



