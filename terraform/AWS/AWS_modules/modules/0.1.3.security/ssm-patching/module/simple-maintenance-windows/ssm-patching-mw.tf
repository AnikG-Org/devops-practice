

resource "aws_ssm_patch_group" "scan_patchgroup" {
  count       = length(var.scan_patch_groups)
  baseline_id = var.aws_ssm_patch_baseline_id
  patch_group = element(var.scan_patch_groups, count.index)
}

resource "aws_ssm_patch_group" "install_patchgroup" {
  count       = length(var.install_patch_groups)
  baseline_id = var.aws_ssm_patch_baseline_id
  patch_group = element(var.install_patch_groups, count.index)
}

resource "aws_ssm_maintenance_window" "scan_window" {
  name     = var.name-var.envname-patch-maintenance-scan-mw
  schedule = var.scan_maintenance_window_schedule
  duration = var.maintenance_window_duration
  cutoff   = var.maintenance_window_cutoff

  tags = local.tags
}

resource "aws_ssm_maintenance_window" "install_window" {
  name     = var.name-var.envname-patch-maintenance-install-mw
  schedule = var.install_maintenance_window_schedule
  duration = var.maintenance_window_duration
  cutoff   = var.maintenance_window_cutoff

  tags = local.tags
}

resource "aws_ssm_maintenance_window_target" "target_scan" {
  count         = length(var.scan_patch_groups)
  window_id     = aws_ssm_maintenance_window.scan_window.id
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = [element(var.scan_patch_groups, count.index)]
  }
}

resource "aws_ssm_maintenance_window_task" "task_scan_patches" {
  window_id        = aws_ssm_maintenance_window.scan_window.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.target_scan.*.id]
  }

  task_parameters {
    name   = "Operation"
    values = ["Scan"]
  }

  logging_info {
    s3_bucket_name = var.ssm_patch_log_bucket_id
    s3_region      = var.aws_region
  }
}

resource "aws_ssm_maintenance_window_target" "target_install" {
  window_id     = aws_ssm_maintenance_window.install_window.id
  resource_type = "INSTANCE"

  targets {
    key    = "tag:Patch Group"
    values = [element(var.install_patch_groups, count.index)]
  }
}

resource "aws_ssm_maintenance_window_task" "task_install_patches" {
  window_id        = aws_ssm_maintenance_window.install_window.id
  task_type        = "RUN_COMMAND"
  task_arn         = "AWS-ApplyPatchBaseline"
  priority         = 1
  service_role_arn = aws_iam_role.ssm_maintenance_window.arn
  max_concurrency  = var.max_concurrency
  max_errors       = var.max_errors

  targets {
    key    = "WindowTargetIds"
    values = [aws_ssm_maintenance_window_target.target_install.*.id]
  }

  task_parameters {
    name   = "Operation"
    values = ["Install"]
  }

  logging_info {
    s3_bucket_name = var.ssm_patch_log_bucket_id
    s3_region      = var.aws_region
  }
}

#IAM
resource "aws_iam_role" "ssm_maintenance_window" {
  name = "${var.name}-${var.envname}-${var.envtype}-ssm-mw-role"
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
  role       = "${aws_iam_role.ssm_maintenance_window.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonSSMMaintenanceWindowRole"
}