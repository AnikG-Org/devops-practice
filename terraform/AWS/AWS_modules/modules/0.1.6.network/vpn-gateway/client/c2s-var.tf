variable "client_vpn_cidr_block" {
  description = "Add the IPv4 address range, in CIDR notation, from which to assign client IP Address must be either /16 or /22 address space"
  type        = string
  default     = "192.168.8.0/22"
}
variable "name" {
  description = "The name prefix for the VPN client resources"
  type        = string
  default     = "vpn-client"
}
# variable "private_subnet_count" {
#   description = "Number of private subnets in the VPC"
#   type        = number
#   default     = 2
# }
# variable "public_subnet_count" {
#   description = "Number of public subnets in the VPC"
#   type        = number
#   default     = 0
# }
variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
  default     = []
}

variable "root_certificate_chain_arn" {
  description = "The ARN of the client certificate. The certificate must be signed by a certificate authority (CA) and it must be provisioned in AWS Certificate Manager (ACM)."
  type        = string
  default     = ""
}

variable "server_certificate_arn" {
  description = "The server certificate ARN."
  type        = string
}

variable "split_tunnel" {
  description = "Enables/disables split tunnel on the Client VPN."
  type        = bool
  default     = false
}
variable "vpc_id" {
  description = "VPC ID"
  type        = string
}
variable "description" { default = "" }
variable "type" { default = "certificate-authentication" } #Specify certificate-authentication to use certificate-based authentication, directory-service-authentication to use Active Directory authentication, or federated-authentication to use Federated Authentication via SAML 2.0.
variable "active_directory_id" { default = "" }
variable "saml_provider_arn" { default = "" }
variable "transport_protocol" { default = "tcp" } #udp
# variable "target_network_cidr" { default = "0.0.0.0/0" }
# variable "self_service_saml_provider_arn" { default = "" }
# variable "authorize_all_groups" {
#   type        = bool
#   default     = true  
# }
# variable "access_group_id" { default = "" }
variable "aws_ec2_client_vpn_authorization_rule" {
  type    = map(map(any))
  default = {}
}
variable "aws_ec2_client_vpn_route" {
  type    = map(map(any))
  default = {}
}
