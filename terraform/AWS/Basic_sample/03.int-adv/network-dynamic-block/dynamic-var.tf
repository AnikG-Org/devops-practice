variable "sg_ports" {
  type        = list(number)
  description = "list of ingress ports for SG 1"
  default     = [8200, 8300, 9200, 53, 3389, 22]
}

variable "sg_ports_1" {
  type        = list(number)
  description = "list of ingress ports for SG 2"
  default     = [8080, 80, 443]
}

variable "myec2sgcidr_1" {
  type        = string
  description = "list of ingress CIDR for SG"
  default     = "0.0.0.0/0"
}