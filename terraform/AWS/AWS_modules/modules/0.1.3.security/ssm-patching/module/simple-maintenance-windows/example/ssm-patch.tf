module "ssm-patching" {
  source = "../"
  
  aws_ssm_patch_baseline_id           = ""
  
  envtype                             = "${var.envtype}"
  scan_maintenance_window_schedule    = "cron(0 0 17 ? * SUN *)"
  install_maintenance_window_schedule = "cron(0 0 20 ? * SUN *)"
  ssm_patch_log_bucket_id             = "bucket-id"
}