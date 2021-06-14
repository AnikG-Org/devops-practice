variable "aws_vpc_id" {
  type = string
}
variable "dynamicsg_security_groups" {
  type        = list(string)
  description = "list of ingress SG for SG"
}
variable "sg_custom_name01" {}

variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports for SG"
}
variable "dynamicsg_protocol" {
  type        = string
  description = "list of ingress ports for SG 1"
  default     = "all"
}
variable "dynamicsg_cidr_block_1" {
  type        = list(string)
  description = "list of ingress CIDR for SG"
}

variable "dynamicsg_ipv6_cidr_blocks" {
  type        = list(string)
  description = "list of ingress IPV6 CIDR for SG"
}