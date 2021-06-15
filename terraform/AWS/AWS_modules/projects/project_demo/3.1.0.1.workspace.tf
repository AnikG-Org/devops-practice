################################ aws_workspaces_directory ################################
module "aws_workspaces_directory" {
  source = "../../modules/0.1.4.compute/workspace"

  enable_workspaces_directory = false
  directory_id                = null #module.directory_service.id[0]
  ip_group_ids                = null #[module.workspace_ip_group.ip_group_id[0]]
  subnet_ids                  = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
  tags                        = {}

  self_service_permissions = [{
    change_compute_type  = true
    increase_volume_size = true
    rebuild_workspace    = true
    restart_workspace    = true
    switch_running_mode  = true
  }]

  workspace_access_properties = [{
    device_type_android    = "ALLOW"
    device_type_chromeos   = "ALLOW"
    device_type_ios        = "ALLOW"
    device_type_osx        = "ALLOW"
    device_type_web        = "DENY"
    device_type_windows    = "DENY"
    device_type_zeroclient = "DENY"
  }]

  workspace_creation_properties = [{
    custom_security_group_id            = module.count_security_groups_4.output_dynamicsg_v2[0]
    default_ou                          = "OU=AWS,DC=Workgroup,DC=Example,DC=com"
    enable_internet_access              = true
    enable_maintenance_mode             = true
    user_enabled_as_local_administrator = true
  }]
}

############################   Work Space ############################
module "workspace" {
  source = "../../modules/0.1.4.compute/workspace"

  enable_workspace = false

  bundle_id                      = module.workspace.ws_bundle_id.standard_windows_10
  directory_id                   = null #module.directory_service.id[0]
  root_volume_encryption_enabled = false
  user_name                      = "admin"
  user_volume_encryption_enabled = false

  volume_encryption_key = null

  timeouts = [{
    create = null
    delete = null
    update = null
  }]

  workspace_properties = [{
    compute_type_name                         = "VALUE"
    root_volume_size_gib                      = 80
    running_mode                              = "AUTO_STOP"
    running_mode_auto_stop_timeout_in_minutes = 60
    user_volume_size_gib                      = 10
  }]
  tags = {
    Used_For = "WFH"
  }
}
##################  #aws_workspaces_ip_group ##################
module "workspace_ip_group" {
  source = "../../modules/0.1.4.compute/workspace"

  enable_workspace_ip_group = false

  ip_group_name = "ip-pool"
  description   = "Contractors IP access control group"
  rules = [
    {
      source      = "150.24.14.0/24"
      description = "NY"
    },
    {
      source      = "44.98.100.0/24"
      description = "IN"
    },
  ]
  tags = {
    Used_For = "WFH"
  }
}
################################################################