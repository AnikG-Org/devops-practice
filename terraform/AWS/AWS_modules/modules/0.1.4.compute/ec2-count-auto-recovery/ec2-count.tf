#/*  Count index for ec2- autorecovery
data "aws_region" "current" {}
locals {
  enable_auto_recovery_alarm    = var.enable_auto_recovery_alarm
  enable_public_route53_record  = var.enable_public_route53_record
  enable_private_route53_record = var.enable_private_route53_record
}

resource "aws_instance" "ec2_count" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  subnet_id                   = var.subnet_id
  key_name                    = var.key_name
  monitoring                  = var.monitoring                  #true
  associate_public_ip_address = var.associate_public_ip_address #false
  user_data                   = var.user_data
  user_data_base64            = var.user_data_base64 #filebase64("/userdata.sh")
  security_groups             = var.security_groups
  vpc_security_group_ids      = var.vpc_security_group_ids #If you are creating Instances in a VPC, use vpc_security_group_ids instead.

  private_ip = element(concat(var.private_ips, [""]), count.index)
  credit_specification { cpu_credits   = var.cpu_credits }
  source_dest_check                    = var.source_dest_check       #true
  disable_api_termination              = var.disable_api_termination #false
  instance_initiated_shutdown_behavior = var.instance_initiated_shutdown_behavior
  tenancy                              = var.tenancy
  ebs_optimized                        = var.ebs_optimized

  tags = merge(
    var.additional_tags,
    {
      Name              = "${var.ec2tagname}${count.index + 001}"
      #timestamp         = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
      instance_sequence = count.index + 001
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [tags.timestamp]
  }
  root_block_device {
    volume_type           = var.root_block_volume_type
    volume_size           = var.root_block_volume_size
    iops                  = var.root_block_device_iops
    encrypted             = var.root_block_device_encryption
    kms_key_id            = var.kms_key_id
    delete_on_termination = var.root_block_device_delete_on_termination
    tags = merge(
      var.additional_tags,
      {
        Name           = "${var.ec2tagname}${count.index + 001}-root-block"
        #timestamp      = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
        block_sequence = count.index + 001
        Environment     = var.environment
        Created_Via     = "Terraform IAAC"
        Project         = var.project
        SCM             = var.git_repo
        ServiceProvider = var.ServiceProvider 
        block_device   = "Root-Volume"      
      },
      var.tags
    )
  }

  dynamic "ephemeral_block_device" {
    for_each = var.ephemeral_block_device
    content {
      device_name  = ephemeral_block_device.value.device_name
      no_device    = lookup(ephemeral_block_device.value, "no_device", null)
      virtual_name = lookup(ephemeral_block_device.value, "virtual_name", null)
    }
  }
  dynamic "metadata_options" {
    for_each = length(keys(var.metadata_options)) == 0 ? [] : [var.metadata_options]
    content {
      http_endpoint               = lookup(metadata_options.value, "http_endpoint", "enabled")
      http_tokens                 = lookup(metadata_options.value, "http_tokens", "optional")
      http_put_response_hop_limit = lookup(metadata_options.value, "http_put_response_hop_limit", "1")
    }
  }

  depends_on = [var.ec2_count_depends_on]
}

resource "aws_cloudwatch_metric_alarm" "auto_recovery_alarm" {
  count = local.enable_auto_recovery_alarm ? var.instance_count : 0
  #count              = var.instance_count
  alarm_name          = "EC2AutoRecover-${element(aws_instance.ec2_count.*.id, count.index)}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "StatusCheckFailed_System"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Minimum"

  dimensions = {
    InstanceId = element(aws_instance.ec2_count.*.id, count.index)
  }
  threshold         = var.threshold
  alarm_actions     = ["arn:aws:automate:${data.aws_region.current.name}:ec2:recover"]
  alarm_description = "Auto recover the EC2 instance if Status Check fails."
}

resource "aws_route53_record" "public_route53_record" {
  count = local.enable_public_route53_record ? var.instance_count : 0
  #count   = var.count
  zone_id = var.route53_hosted_zone_id
  name    = var.record_name
  type    = "A"
  ttl     = "60"

  weighted_routing_policy {
    weight = 10
  }
  set_identifier = element(aws_instance.ec2_count.*.id, count.index)

  records        = [element(aws_instance.ec2_count.*.public_ip, count.index)]
  #health_check_id = element(aws_route53_health_check.route53_health_check.*.id, count.index)
}
resource "aws_route53_record" "private_route53_record" {
  count = local.enable_private_route53_record ? var.instance_count : 0
  #count   = var.count
  zone_id = var.route53_hosted_zone_id
  name    = var.record_name
  type    = "A"
  ttl     = "60"

  weighted_routing_policy {
    weight = 10
  }
  set_identifier = element(aws_instance.ec2_count.*.id, count.index)
  
  records        = [element(aws_instance.ec2_count.*.private_ip, count.index)]
  #health_check_id = element(aws_route53_health_check.route53_health_check.*.id, count.index)
}

