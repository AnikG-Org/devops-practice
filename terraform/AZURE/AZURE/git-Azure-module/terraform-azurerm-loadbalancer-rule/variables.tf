variable "lb_rule_specs" {
  description = "Load balancer rules specifications"
  type        = list(map(string))
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "loadbalancer_id" {
  description = "ID of the load balancer"
  type        = string
}

variable "backend_address_pool_id" {
  description = "Backend address pool id for the load balancer"
  type        = string
}

variable "probe_id" {
  description = "ID of the loadbalancer probe"
  type        = string
  default     = ""
}

variable "load_distribution" {
  description = "Specifies the load balancing distribution type to be used by the Load Balancer. Possible values are: Default – The load balancer is configured to use a 5 tuple hash to map traffic to available servers. SourceIP – The load balancer is configured to use a 2 tuple hash to map traffic to available servers. SourceIPProtocol – The load balancer is configured to use a 3 tuple hash to map traffic to available servers. Also known as Session Persistence, where the options are called None, Client IP and Client IP and Protocol respectively."
  type        = string
  default     = ""
}

