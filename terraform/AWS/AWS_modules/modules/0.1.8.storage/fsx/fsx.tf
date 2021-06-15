

resource "aws_fsx_windows_file_system" "this" {

  active_directory_id               = var.active_directory_id
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  copy_tags_to_backups              = var.copy_tags_to_backups
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  deployment_type                   = var.deployment_type
  kms_key_id                        = var.kms_key_id
  preferred_subnet_id               = var.preferred_subnet_id
  security_group_ids                = var.security_group_ids
  skip_final_backup                 = var.skip_final_backupr
  storage_capacity                  = var.storage_capacity
  storage_type                      = var.storage_type
  subnet_ids                        = var.subnet_ids
  throughput_capacity               = var.throughput_capacity
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time
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
  dynamic "self_managed_active_directory" {
    for_each = var.self_managed_active_directory
    content {
      dns_ips                                = self_managed_active_directory.value["dns_ips"]
      domain_name                            = self_managed_active_directory.value["domain_name"]
      file_system_administrators_group       = self_managed_active_directory.value["file_system_administrators_group"]
      organizational_unit_distinguished_name = self_managed_active_directory.value["organizational_unit_distinguished_name"]
      password                               = self_managed_active_directory.value["password"]
      username                               = self_managed_active_directory.value["username"]
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }

}