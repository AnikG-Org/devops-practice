variable "name" {

}
variable "resource_group_name" {

}
variable "location" {

}
variable "databricks_sku" {
}
variable "tags" {
  description = "Tags to be attached to synapse-workspace"
  default     = {}
  type        = map 
    
}
#variable "no_public_ip" {
#}
#variable "public_subnet_name" {
#}
#variable "private_subnet_name" {
#}
#variable "virtual_network_id" {
#}

