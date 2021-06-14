resource "aws_workspaces_directory" "this" {
  count        = var.enable_workspaces_directory ? 1 : 0
  directory_id = var.directory_id
  ip_group_ids = var.ip_group_ids
  subnet_ids  = var.subnet_ids

  dynamic "self_service_permissions" {
    for_each = var.self_service_permissions
    content {    
      change_compute_type = self_service_permissions.value["change_compute_type"]      
      increase_volume_size = self_service_permissions.value["increase_volume_size"]     
      rebuild_workspace = self_service_permissions.value["rebuild_workspace"]
      restart_workspace = self_service_permissions.value["restart_workspace"]
      switch_running_mode = self_service_permissions.value["switch_running_mode"]
    }
  }
  dynamic "workspace_access_properties" {
    for_each = var.workspace_access_properties
    content {    
      device_type_android = workspace_access_properties.value["device_type_android"]      
      device_type_chromeos = workspace_access_properties.value["device_type_chromeos"]     
      device_type_ios = workspace_access_properties.value["device_type_ios"]
      device_type_osx = workspace_access_properties.value["device_type_osx"]
      device_type_web = workspace_access_properties.value["device_type_web"]
      device_type_windows = workspace_access_properties.value["device_type_windows"]
      device_type_zeroclient = workspace_access_properties.value["device_type_zeroclient"]
    }
  }
  dynamic "workspace_creation_properties" {
    for_each = var.workspace_creation_properties
    content {
      custom_security_group_id = workspace_creation_properties.value["custom_security_group_id"]
      default_ou = workspace_creation_properties.value["default_ou"]
      enable_internet_access = workspace_creation_properties.value["enable_internet_access"]
      enable_maintenance_mode = workspace_creation_properties.value["enable_maintenance_mode"]
      user_enabled_as_local_administrator = workspace_creation_properties.value["user_enabled_as_local_administrator"]
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.workspaces_default_service_access,
    aws_iam_role_policy_attachment.workspaces_default_self_service_access
  ]
  tags = var.tags  
}
###############################################
resource "random_string" "name" {
  count   = var.enable_workspaces_directory ? 1 : 0
  length  = "10"
  special = false
  number  = true
  upper   = false
}
locals {
  random_name = random_string.name[*].result
}
##################### IAM #####################
data "aws_iam_policy_document" "workspaces" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["workspaces.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "workspaces_default" {
  count              = var.enable_workspaces_directory ? 1 : 0
  name               = "workspaces_DefaultRole-${local.random_name[0]}"
  assume_role_policy = data.aws_iam_policy_document.workspaces.json
}
resource "aws_iam_role_policy_attachment" "workspaces_default_service_access" {
  count      = var.enable_workspaces_directory ? 1 : 0
  role       = aws_iam_role.workspaces_default[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesServiceAccess"
}
resource "aws_iam_role_policy_attachment" "workspaces_default_self_service_access" {
  count      = var.enable_workspaces_directory ? 1 : 0
  role       = aws_iam_role.workspaces_default[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonWorkSpacesSelfServiceAccess"
}
##################### VAR #####################
variable "enable_workspaces_directory" {
  type        = bool
  default     = false  
}
variable "ip_group_ids" {
  description = "(optional)"
  type        = set(string)
  default     = null
}
variable "subnet_ids" {
  description = "(optional)"
  type        = set(string)
  default     = null
}
variable "self_service_permissions" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      change_compute_type  = bool
      increase_volume_size = bool
      rebuild_workspace    = bool
      restart_workspace    = bool
      switch_running_mode  = bool
    }
  ))
  default = []
}
variable "workspace_access_properties" {
  type = set(object(
    {
    device_type_android    = string
    device_type_chromeos   = string
    device_type_ios        = string
    device_type_osx        = string
    device_type_web        = string
    device_type_windows    = string
    device_type_zeroclient = string
    }
  ))
  default = []
}
variable "workspace_creation_properties" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      custom_security_group_id            = string
      default_ou                          = string
      enable_internet_access              = bool
      enable_maintenance_mode             = bool
      user_enabled_as_local_administrator = bool
    }
  ))
  default = []
}  
########################## #OP aws_workspaces_directory #####################

output "alias" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.alias
}

output "customer_user_name" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.customer_user_name
}

output "directory_name" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.directory_name
}

output "directory_type" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.directory_type
}

output "dns_ip_addresses" {
  description = "returns a set of string"
  value       = aws_workspaces_directory.this.*.dns_ip_addresses
}

output "iam_role_id" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.iam_role_id
}

output "aws_workspaces_directory_id" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.id
}

output "ip_group_ids" {
  description = "returns a set of string"
  value       = aws_workspaces_directory.this.*.ip_group_ids
}

output "registration_code" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.registration_code
}

output "self_service_permissions" {
  description = "returns a list of object"
  value       = aws_workspaces_directory.this.*.self_service_permissions
}

output "subnet_ids" {
  description = "returns a set of string"
  value       = aws_workspaces_directory.this.*.subnet_ids
}

output "workspace_access_properties" {
  description = "returns a list of object"
  value       = aws_workspaces_directory.this.*.workspace_access_properties
}

output "workspace_creation_properties" {
  description = "returns a list of object"
  value       = aws_workspaces_directory.this.*.workspace_creation_properties
}

output "workspace_security_group_id" {
  description = "returns a string"
  value       = aws_workspaces_directory.this.*.workspace_security_group_id
}

output "aws_workspaces_directory" {
  value = aws_workspaces_directory.this[*]
}
###############################################################