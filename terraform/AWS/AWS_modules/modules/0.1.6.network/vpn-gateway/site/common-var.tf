####################################################### locals common
variable "existing_vpn_gateway" {
  description = "The id of an existing VPN gateway to use for the VPN.  Must be provided if not creating a VPN gateway."
  type        = string
  default     = null
}
variable "existing_customer_gateway" {
  description = "The id of an existing customer gateway to use for the VPN.  Must be provided if not creating a customer gateway."
  type        = string
  default     = null
}
####################################################### cgw
variable "create_cgw" {
  description = "Whether to create Customer Gateway resources"
  type        = bool
  default     = true
}
variable "customer_gateways" {
  description = "Maps of Customer Gateway's attributes (BGP ASN and Gateway's Internet-routable external IP address)"
  type        = map(map(any))
  default     = {}
}
variable "customer_gateway_tags" { default = "" }
####################################################### vgw
variable "vpc_id" {
  description = "Provide Virtual Private Cloud ID in which the VPN resources will be deployed"
  type        = string
  default     = null
}
variable "enable_vpn_gateway" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = false
}
variable "vpn_gateway_attachment" {
  description = "Should be true if you want to create a new VPN Gateway resource and attach it to the VPC"
  type        = bool
  default     = true
}
variable "amazon_side_asn" {
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. By default the virtual private gateway is created with the current default Amazon ASN."
  type        = string
  default     = "64512"
}
variable "availability_zone" {
  description = "The Availability Zone for the VPN Gateway"
  type        = string
  default     = null
}
variable "customvgwname" { default = "VGW" }
variable "spoke_vpc" {
  description = "Boolean value to determine if VPC is a spoke in a VPN Hub."
  type        = bool
  default     = false
}
variable "vpn_gateway_tags" {
  description = "Additional tags for the VPN gateway"
  type        = map(string)
  default     = {}
}
variable "vpn_gateway_id" {
  description = "ID of VPN Gateway to attach to the VPC"
  type        = string
  default     = ""
}
####################################################### VPN Connection
variable "create_vpn_connection" {
  type        = bool
  default     = true
}
variable "transit_gateway_id" {
  description = "Attach if existing transit_gateway in place insted of VGW"
  type        = string
  default     = null
}
variable "disable_bgp" {
  description = "Boolean value to determine if BGP routing protocol should be disabled for the VPN connection.  If static routes are required for this VPN this value should be set to true."
  type        = bool
  default     = true
}
variable "bgp_inside_cidrs" {
  description = "Pre-shared key (PSK) to establish initial authentication between the virtual private gateway and customer gateway. Allowed characters are alphanumeric characters and ._. Must be between 8 and 64 characters in length and cannot start with zero (0), #Always use **aws_kms_key** to manage sensitive information. Use it in conjunction with variable **preshared_keys**.  Example [\"XXXX\",\"XXXX\"]"
  type        = list(string)
  default     = []
}
variable "preshared_keys" {
  description = "The pre-shared key (PSK) to establish initial authentication between the virtual private gateway and customer gateway. Allowed characters are alphanumeric characters and ._. Must be between 8 and 64 characters in length and cannot start with zero (0)."
  type        = list(string)
  default     = []
}
variable "static_routes" {
  description = "A list of internal subnets on the customer side. The subnets must be in valid CIDR notation(x.x.x.x/x)."
  type        = list(string)
  default     = []
}
variable "bgp_asn" {
  description = "An existing ASN assigned to the remote network, or one of the private ASNs in the 64512 - 65534 range.  Exceptions: 7224 cannot be used in the us-east-1 region and 9059 cannot be used in eu-west-1 region."
  type        = number
  default     = 65000
}
# variable "enable_acceleration" {
#   type        = bool
#   default     = false
#   description = "(Optional, Default false) Indicate whether to enable acceleration for the VPN connection. Supports only EC2 Transit Gateway."
# }
# variable "local_ipv4_network_cidr" { default = "0.0.0.0/0"}
# variable "remote_ipv4_network_cidr" { default = "0.0.0.0/0"}
# variable "local_ipv6_network_cidr" { default = "::/0"}
# variable "remote_ipv6_network_cidr" { default = "::/0"}
####################################################### route propagation
variable "enable_route_propagation" {
  type        = bool
  default     = true  
}

variable "route_tables" {
  description = "A list of route tables to configure for route propagation."
  type        = list(string)
  default     = []
}