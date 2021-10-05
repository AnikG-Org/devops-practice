variable "name" {
  description = "(Required) Specifies the name of the Front Door service. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "(Required) Specifies the name of the Resource Group in which the Front Door service should exist. Changing this forces a new resource to be created."
  type        = string
}

variable "routing_rules" {
  description = "Required: Rules on how to match the requests"
  type = list(object({
    name : string
    accepted_protocols : list(string)
    patterns_to_match : list(string)
    frontend_endpoints : list(string)
    enabled : bool
    forwarding_configuration : list(object({
      forwarding_protocol : string
      backend_pool_name : string
      }
    ))
    redirect_configuration : list(object({
      custom_host : string
      redirect_protocol : string
      redirect_type : string
      custom_fragment : string
      custom_path : string
      custom_query_string : string
      }
    ))
  }))
  default = [{
    "name" : null,
    "accepted_protocols" : [],
    "patterns_to_match" : [],
    "frontend_endpoints" : [],
    "enabled" : null,
    "forwarding_configuration" : [],
    "redirect_configuration" : [{
      "custom_host" : null,
      "redirect_protocol" : "MatchRequest",
      "redirect_type" : "TemporaryRedirect",
      "custom_fragment" : null,
      "custom_path" : null,
      "custom_query_string" : null
    }]
  }]
}

variable "backend_pool_load_balancing" {
  description = "Required Field 'name'. Allows tuning of samples otherwise defaults are used"
  type = object({
    name : string
    sample_size : number
    successful_samples_required : number
    additional_latency_milliseconds : number
  })
  default = {
    "name" : null,
    "sample_size" : null,
    "successful_samples_required" : null,
    "additional_latency_milliseconds" : null
  }
}

variable "backend_pool" {
  description = "Name for backend pool"
  type = object({
    name : string
    host_header : string
    address : string
    http_port : number
    https_port : number
    load_balancing_name : string
    health_probe_name : string
    }
  )
  default = {
    "name" : null,
    "host_header" : null,
    "address" : null,
    "http_port" : null,
    "https_port" : null,
    "load_balancing_name" : null,
    "health_probe_name" : null
  }
}

variable "frontend_endpoint" {
  description = "Required fields name, hostname: Frontend end_point Settings"
  type = object({
    name : string
    session_affinity_ttl_seconds : number
  })
  default = {
    name : "fpoint1",
    session_affinity_ttl_seconds : 2
  }
}

variable "backend_pool_health_probe" {
  description = "Required fields name. Setting for backend health probe."
  type = object({
    name : string
    enabled : bool
    path : string
    protocol : string
    probe_method : string
    interval_in_seconds : number
  })
  default = {
    "name" : null,
    "enabled" : null,
    "path" : null,
    "protocol" : null,
    "probe_method" : null,
    "interval_in_seconds" : null
  }
}

variable "custom_https_configuration" {
  description = ""
  type = list(object({
    certificate_source : string
    azure_key_vault_certificate_secret_name : string
    azure_key_vault_certificate_vault_id : string
  }))
  default = []
}

variable "custom_https_provisioning_enabled" {
  description = ""
  type        = string
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Tags to be attached to the policy."
}