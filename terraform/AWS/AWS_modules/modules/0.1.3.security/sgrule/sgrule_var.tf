variable "create_sg_rule" {
  description = "Whether to create security group rules"
  type        = bool
  default     = true
}
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}
variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}
variable "aws_vpc_id" { default = "" }
variable "sgrule_security_group_id" {
  type        = string 
  default     = ""
}
# variable "from_sgrule_ports" {
#   type        = set(string)
#   description = "list of ingress from_ports for SG"
#   default     = [] 
# }
# variable "sgrule_description" {} #description = "SG rule description"
# variable "sgrule_protocol" {}    #description = "SG rule protocol type"
variable "sgrule_prefix_list_ids" {
  type        = list(string)
  description = "list of ingress prefix_list_ids for SG"
  default     = [] 
}
variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "ingress list of CIDR for SG"
  default     = [] 
}
variable "sgrule_ipv6_cidr_blocks" {
  type        = list(string)
  description = "list of ingress IPV6 CIDR for SG"
  default     = [] 
}