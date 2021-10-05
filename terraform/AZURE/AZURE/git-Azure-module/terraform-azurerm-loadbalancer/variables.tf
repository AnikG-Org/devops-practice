###  Mandatory input variables  ###

variable "name" {
  description = "The name of load balancer to be created"
  type        = string
}

variable "resource_group_name" {
  description = "The name of existing resource group in which load balancer is to be created"
  type        = string
}

variable "location" {
  description = "The Azure region where the resource group is to be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
  type        = string
}

###  Optional input variables  ###

variable "tags" {
  description = "Map of tags to be attached to the load balancer"
  type        = map(string)
  default     = {}
}

variable "sku" {
  description = "SKU for load balancer"
  type        = string
  default     = "Standard"
}

variable "lb_frontend_ip_configuration_name" {
  description = "Load Balancer Frontend IP configuration name"
  type        = string
  default     = "LBFrontendIPConfig"
}

variable "lb_frontend_ip_configuration_subnet_id" {
  description = "ID of the Subnet which should be associated with the Load Balancer's IP Configuration"
  type        = string
  default     = null
}

variable "private_ip_address" {
  description = "Private IP Address to assign to the Load Balancer"
  type        = string
  default     = null
}

variable "private_ip_address_allocation" {
  description = "The allocation method for the Private IP Address used by this Load Balancer (Dynamic/Static)"
  type        = string
  default     = "Dynamic"
}

variable "public_ip_address_id" {
  description = "ID of a Public IP Address which should be associated with the Load Balancer"
  type        = string
  default     = null
}

variable "vm_nics" {
  description = "List of VM nic ID's to associate with the load balancer"
  type        = list(object({nic_id = string, ip_config_name = string}))
  default     = []
}

variable "lb_ports" {
  description = "Ports to be used for mapping frontend to backend ports on the load balancer."
  type        = list(object({frontend_port = number, backend_port = number, protocol = string, has_probe = bool}))
  default     = [{frontend_port = 443, backend_port = 443, protocol = "tcp", has_probe = false}]
}

variable "lb_probe_ports" {
  description = "Ports to be used for lb health probes."
  type        = any
  default     = [{backend_port = 8080, protocol = "tcp"}]
}

variable "lb_nat_rules" {
  description = "NAT rules to associate to the load balancer"
  type        = list(object({protocol = string, frontend_port = number, backend_port = number, ip_config = string}))
  default     = []
}

variable "lb_probe_unhealthy_threshold" {
  description = "Number of times the load balancer health probe has an unsuccessful attempt before considering the endpoint unhealthy."
  type        = number
  default     = 2
}

variable "lb_probe_interval" {
  description = "Interval in seconds the load balancer health probe rule does a check"
  type        = number
  default     = 5
}

variable "load_distribution" {
  description = "Specifies the load balancing distribution type to be used by the Load Balancer."
  type        = string
  default     = "Default"
}

variable "idle_timeout_minutes" {
  description = "Timeout for the tcp idle connection in minutes"
  type        = number
  default     = 5
}

variable "enable_floating_ip" {
  description = "Floating IP is pertinent to failover scenarios: a floating IP is reassigned to a secondary server in case the primary server fails. Floating IP is required for SQL AlwaysOn."
  type        = bool
  default     = false
}

variable "backend_pool_id" {
  description = "Optional backend pool id to ensure association and proper ordering in Terraform DAG"
  type        = string
  default     = null
}