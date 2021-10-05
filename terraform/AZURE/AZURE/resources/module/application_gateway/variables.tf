# Mandatory variables

variable "name" {
  description = "Name for azure application gateway"
}

variable "resource_group_name" {
  description = "Resource group name in which the application gateway is to be created"
}

variable "location" {
  description = "The Azure region where the ASG is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "sku_name" {
  description = "SKU name for application gateway"
}

variable "sku_tier" {
  description = "SKU tier for application gateway"
}

variable "sku_capacity" {
  description = "SKU capacity for application gateway"
}

variable "subnet_id" {
  description = "Subnet ID in which application gateway must be created."
}

variable "frontend_port_no" {
  description = "Frontend port number for application gateway"
}

variable "cookie_based_affinity" {
  description = "Is Cookie-Based affinity enabled? (Enabled/Disabled)"
}

variable "backend_http_port" {
  description = "HTTP port for backend HTTP setting"
}

variable "backend_http_protocol" {
  description = "Protocol to be used (HTTP/HTTPS)"
}

variable "http_listener_protocol" {
  description = "HTTP listner protocol (HTTP/HTTPS)"
}

variable "routing_rule_type" {
  description = "Routing rule type (Basic/PathBasedRouting)"
}

# Optional variables
variable "heathprobe_timeout" {
  description = "Health probe timeout for application gateway (seconds)"
  default     = 30
}

variable "heathprobe_interval" {
  description = "Health probe interval for application gateway (seconds)"
  default     = 30
}

variable "heathprobe_unhealthy_threshold" {
  description = "Health probe unhealthy threshold (seconds)"
  default     = 2
}

variable "healthprobe_match_response_body" {
  description = "Health probe response body to match"
  default     = "*"
}

variable "healthprobe_match_statuscodes" {
  description = "Health probe status codes to match"
  default     = []
  type        = list
}

variable "backend_request_timeout_in_seconds" {
  description = "Backend HTTP request timeout in seconds"
  default     = 30
}

variable "public_ip_address_id" {
  description = "ID of the public IP address for the application gateway"
  default     = null
}

variable "private_ip_address_allocation" {
  description = "Private IP address allocation (Static/Dynamic)"
  default     = "Dynamic"
}

variable "private_ip_address" {
  description = "Private IP address for the application gateway"
  default     = null
}

variable "path_prefix" {
  description = "Path prefix for all HTTP requests"
  default     = ""
}

variable "tags" {
  description = "Tags to be attached to application gateway"
  default     = {}
  type        = map
}

variable "url_path_rule" {
  description = "URL Path rules"
  default     = []
  type        = list
}