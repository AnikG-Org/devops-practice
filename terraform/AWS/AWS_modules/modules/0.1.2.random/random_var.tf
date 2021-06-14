########### For random password ##############################
variable "pw_leangth" { default = 10 } #max pw leangth 50
variable "pw_special" {
  type    = bool
  default = true
}
########### For random name ##############################
variable "name_length" { default = 20 } #name leangth (string)

variable "name_special" {
  type    = bool
  default = true
}
variable "name_number" {
  type    = bool
  default = true
}
variable "name_upper" {
  type    = bool
  default = true
}
###################For random pet #############################

variable "random_pet_length" {
  type    = number
  default = 3
}