module "aws_fsx_windows_file_system" {
  source          = "../"
  provider_region = var.provider_region

  active_directory_id               = null          # active_directory_id - (optional) is a type of string 
  automatic_backup_retention_days   = 0             # automatic_backup_retention_days - (optional) is a type of number 
  copy_tags_to_backups              = null          # daily_automatic_backup_start_time - (optional) is a type of string
  daily_automatic_backup_start_time = null          # copy_tags_to_backups - (optional) is a type of bool 
  deployment_type                   = "SINGLE_AZ_1" # deployment_type - (optional) is a type of string 
  kms_key_id                        = null          # kms_key_id - (optional) is a type of string 
  preferred_subnet_id               = null          # preferred_subnet_id - (optional) is a type of string 
  security_group_ids                = []            # security_group_ids - (optional) is a type of set of string 
  skip_final_backup                 = false         # skip_final_backup - (optional) is a type of bool 
  storage_capacity                  = 32            # storage_capacity - (required) is a type of number 
  storage_type                      = "SSD"         # storage_type - (optional) is a type of string 
  subnet_ids                        = []            # subnet_ids - (required) is a type of list of string 
  tags                              = {}
  throughput_capacity               = null # throughput_capacity - (required) is a type of number
  weekly_maintenance_start_time     = null

  self_managed_active_directory = [{
    dns_ips                                = []
    domain_name                            = null
    file_system_administrators_group       = null
    organizational_unit_distinguished_name = null
    password                               = null
    username                               = null
  }]

  timeouts = [{
    create = null
    delete = null
    update = null
  }]
}