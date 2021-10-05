variable "name" {
  description = "Name of the traffic manager to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Traffic Manager."
  type        = string
}

variable "relative_name" {
  description = "The relative domain name,this is combined with the domain name used by Traffic Manager to form the FQDN which is exported as documented below."
  type        = string
}

variable "traffic_routing_method" {
  description = "Specifies the algorithm used to route traffic, possible values are,Geographic - Traffic is routed based on Geographic regions specified in the Endpoint."
  type        = string
  default     = "Weighted"
}

variable "ttl" {
  description = "The TTL value of the Profile used by Local DNS resolvers and clients."
  type        = string
  default     = "100"
}

variable "protocol" {
  description = "The protocol used by the monitoring checks, supported values are HTTP, HTTPS and TCP."
  type        = string
  default     = "http"
}

variable "port" {
  description = "The port number used by the monitoring checks."
  type        = string
  default     = "80"
}

variable "path" {
  description = "The path used by the monitoring checks. Required when protocol is set to HTTP or HTTPS - cannot be set when protocol is set to TCP."
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Map of tags to be attached to the resource group."
  type        = map(string)
}

variable "interval_in_seconds" {
  description = "Interval in seconds"
  type        = string
}

variable "timeout_in_seconds" {
  description = "Timeout in seconds"
  type        = string
}

variable "tolerated_failures" {
  description = "Tolerated failures"
  type        = string
}
