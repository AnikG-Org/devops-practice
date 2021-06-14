module "random_gen_1" {
  source = "../../modules/0.1.2.random"
  ##For random password
  pw_leangth = 30
  pw_special = "true"
  ##For random name
  name_length  = "20"
  name_special = "false"
  name_number  = "false"
  name_upper   = "false"
  #For Random_pet
  random_pet_length = 3
}
#############################################
output "random_output_demo" {
  value = zipmap(["random_name", "random_pet"], [module.random_gen_1.random_name, module.random_gen_1.random_pet])
}

output "random_password" {
  value     = module.random_gen_1.random_passwd
  sensitive = true
}
##########################################################
########### For random password ##########################
/*
variable "pw_leangth" { default = 10 }              #max pw leangth 50
variable "pw_special" {
  type        = bool
  default     = true   
}
########### For random name ##############################
variable "name_length" { default = 20 }             #name leangth (string)
variable "name_special" {
  type        = bool
  default     = true 
}
variable "name_number" {
  type        = bool
  default     = true 
}
variable "name_upper" {
  type        = bool
  default     = true 
}
########### For random pet ##############################
variable "random_pet_length" {
  type        = number
  default     = 2   
}
*/
