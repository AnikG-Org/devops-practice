variable "single_nat_gateway" {
  description = "Single Nat Gateway or HA Nat Gateway"
  type        = bool
  default     = true
}
variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = true
}
variable "manage_default_route_table" {
  description = "Should be true to manage default route table"
  type        = bool
  default     = false
}
variable "default_route_table_propagating_vgws" {
  description = "List of virtual gateways for propagation"
  type        = list(string)
  default     = []
}
variable "default_route_table_routes" {
  description = "Configuration block of routes. See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table#route"
  type        = list(map(string))
  default     = []
}
variable "default_route_table_tags" {
  description = "Additional tags for the default route table"
  type        = map(string)
  default     = {}
}
variable "instance_tenancy" {
  default     = "default"
  type        = string
  description = "VPC instance tenancy"
}
variable "assign_generated_ipv6_cidr_block" {
  type    = bool
  default = false
}
#NetWork #---------------------------------------
variable "cidr_block" {
  default     = "10.0.0.0/16"
  type        = string
  description = "CIDR block for the VPC"
}
variable "on_prem_cidr_block" {
  default     = []
  type        = list
  description = "CIDR block for On-Prem network"
}
variable "cloud_cidr_block" {
  default     = []
  type        = list
  description = "CIDR block for On-Prem network"
}

variable "public_subnet_cidr_blocks" {
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
  type        = list
  description = "List of public subnet CIDR blocks"
}

variable "private_subnet_cidr_blocks" {
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  type        = list
  description = "List of private subnet CIDR blocks"
}
##---------------------------------------
variable "availability_zones" {
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
  type        = list
  description = "List of Subnet Network availability zones"
}
variable "enable_custom_dhcp_options" {
  description = "Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type"
  type        = bool
  default     = false
}
variable "dhcp_options_domain_name" {
  description = "Specifies DNS name for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}
variable "dhcp_options_domain_name_servers" {
  description = "Specify a list of DNS server addresses for DHCP options set, default to AWS provided (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = ["AmazonProvidedDNS"]
}
variable "dhcp_options_ntp_servers" {
  description = "Specify a list of NTP servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}
variable "dhcp_options_netbios_name_servers" {
  description = "Specify a list of netbios servers for DHCP options set (requires enable_dhcp_options set to true)"
  type        = list(string)
  default     = []
}
variable "dhcp_options_netbios_node_type" {
  description = "Specify netbios node_type for DHCP options set (requires enable_dhcp_options set to true)"
  type        = string
  default     = ""
}
variable "dhcp_options_tags" {
  description = "Additional tags for the DHCP option set (requires enable_dhcp_options set to true)"
  type        = map(string)
  default     = {}
}
#---------------------------------------
#S3 vpc end point
variable "enable_vpc_s3_endpoint" {
  description = "Whether or not to enable VPC enable_vpc_endpoint for s3"
  type        = bool
  default     = false
}
