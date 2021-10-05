output "name" {
  description = "The name of the Application Security Group."
  value       = length(local.asg_name) == 1 ? local.asg_name.name : null
}

output "id" {
  description = "The ID of the Application Security Group."
  value       = length(local.asg_id) == 1 ? local.asg_id.id : null
}

locals {
  asg_id = {
    for value in azurerm_application_security_group.asg.*.id :
    "id" => value
  }
  asg_name = {
    for value in azurerm_application_security_group.asg.*.name :
    "name" => value
  }
}
