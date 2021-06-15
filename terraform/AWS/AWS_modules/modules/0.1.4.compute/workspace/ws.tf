resource "aws_workspaces_workspace" "this" {
  count = var.enable_workspace ? var.ws_count : 0

  bundle_id    = var.bundle_id
  directory_id = var.directory_id
  user_name    = var.user_name

  root_volume_encryption_enabled = var.root_volume_encryption_enabled
  user_volume_encryption_enabled = var.user_volume_encryption_enabled
  volume_encryption_key          = var.volume_encryption_key

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }

  dynamic "workspace_properties" {
    for_each = var.workspace_properties
    content {
      compute_type_name                         = workspace_properties.value["compute_type_name"]
      root_volume_size_gib                      = workspace_properties.value["root_volume_size_gib"]
      running_mode                              = workspace_properties.value["running_mode"]
      running_mode_auto_stop_timeout_in_minutes = workspace_properties.value["running_mode_auto_stop_timeout_in_minutes"]
      user_volume_size_gib                      = workspace_properties.value["user_volume_size_gib"]
    }
  }
  tags = merge(
    {
      Sequence        = count.index + 001
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
#####  #aws_workspaces_ip_group #########
resource "aws_workspaces_ip_group" "this" {
  count       = var.enable_workspace_ip_group ? 1 : 0
  description = var.description
  name        = var.ip_group_name

  dynamic "rules" {
    for_each = var.rules
    content {
      description = rules.value["description"]
      source      = rules.value["source"]
    }
  }
  tags = merge(
    {
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
#####  #aws_workspaces_directory #########
