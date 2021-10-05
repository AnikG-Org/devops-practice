

variable "name" {

}
variable "resource_group_name" {

}
variable "location" {

}


variable "tags" {
  description = "Tags to be attached to application gateway"
  default     = {}
  type        = map
}