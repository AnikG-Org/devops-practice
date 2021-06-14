locals {
  random_string = random_string.name_1.result
  service_role_arn = aws_iam_role.ssm_maintenance_window[0].arn
  iam_service_role_arn = element(
    compact(
      concat(
        local.service_role_arn,        
        [var.service_role_arn],
      ),
    ),
    0,
  )  
}


##################################
# Maintenance Windows for scanning
##################################
resource "aws_ssm_maintenance_window" "scan_window" {
  count    = var.enable_mode_scan ? 1 : 0
  name     = "ssmmaww-${var.environment}-patch-maintenance-scan-mw"
  schedule = var.scan_maintenance_window_schedule
  duration = var.maintenance_window_duration
  cutoff   = var.maintenance_window_cutoff

  tags = local.tags
}

resource "aws_ssm_maintenance_window_task" "task_scan_patches" {
  count            = var.enable_mode_scan ? 1 : 0
  window_id        = aws_ssm_maintenance_window.scan_window[0].id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = var.task_scan_priority
  #service_role_arn = var.service_role_arn
  service_role_arn = local.iam_service_role_arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.target_scan.*.id
  }


  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Scan"]
      }
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
      output_s3_bucket     = var.s3_bucket_name
      output_s3_key_prefix = var.s3_bucket_prefix_scan_logs

      service_role_arn = var.role_arn_for_notification
      dynamic "notification_config" {
        for_each = var.enable_notification_scan ? [1] : []
        content {
          notification_arn    = var.notification_arn
          notification_events = var.notification_events
          notification_type   = var.notification_type
        }
      }
    }
  }
}

resource "aws_ssm_maintenance_window_target" "target_scan" {
  count         = var.enable_mode_scan ? 1 : 0
  window_id     = aws_ssm_maintenance_window.scan_window[0].id
  resource_type = "INSTANCE"

  dynamic "targets" {
    for_each = length(var.scan_maintenance_windows_targets) > 0 ? var.scan_maintenance_windows_targets : []
    content {
      key    = targets.value.key
      values = targets.value.values
    }
  }
  dynamic "targets" {
    for_each = length(var.scan_maintenance_windows_targets) == 0 ? [1] : []
    content {
      key    = "tag:Patch Group"
      values = var.scan_patch_groups
    }
  }
}


##################################
# Maintenance Windows for patching
##################################

resource "aws_ssm_maintenance_window" "install_window" {
  name     = "ssmmaww-${var.environment}-patch-maintenance-install-mw"
  schedule = var.install_maintenance_window_schedule
  duration = var.maintenance_window_duration
  cutoff   = var.maintenance_window_cutoff

  tags = local.tags
}

resource "aws_ssm_maintenance_window_task" "task_install_patches" {
  window_id        = aws_ssm_maintenance_window.install_window.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-RunPatchBaseline"
  priority         = var.task_install_priority
  #service_role_arn = var.service_role_arn
  service_role_arn = local.iam_service_role_arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = aws_ssm_maintenance_window_target.target_install.*.id
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
      parameter {
        name   = "RebootOption"
        values = [var.reboot_option]
      }
      output_s3_bucket     = var.s3_bucket_name
      output_s3_key_prefix = var.s3_bucket_prefix_install_logs

      service_role_arn = var.role_arn_for_notification
      dynamic "notification_config" {
        for_each = var.enable_notification_install ? [1] : []
        content {
          notification_arn    = var.notification_arn
          notification_events = var.notification_events
          notification_type   = var.notification_type
        }
      }
    }
  }
}


resource "aws_ssm_maintenance_window_target" "target_install" {
  window_id     = aws_ssm_maintenance_window.install_window.id
  resource_type = "INSTANCE"
  dynamic "targets" {
    for_each = length(var.install_maintenance_windows_targets) > 0 ? var.install_maintenance_windows_targets : []
    content {
      key    = targets.value.key
      values = targets.value.values
    }
  }

  dynamic "targets" {
    for_each = length(var.install_maintenance_windows_targets) == 0 ? [1] : []
    content {
      key    = "tag:Patch Group"
      values = var.install_patch_groups
    }
  }
}


###############
# Create Custom Role for patchManagement
# and attach AmazonSSMMaintenanceWindowRole policy to the role
###############
resource "random_string" "name_1" {
  length  = 10
  special = false
  number  = true
  upper   = false
}
resource "aws_iam_role" "ssm_maintenance_window" {
  count = enable_ssm_mw_role == true ? 1 : 0
  name = "role-${var.environment}-ssm-mw-role-${local.random_string}"
  path = "/system/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com","ssm.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "role_attach_ssm_mw" {
  count      = enable_ssm_mw_role == true ? 1 : 0

  role       = aws_iam_role.ssm_maintenance_window[0].name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}