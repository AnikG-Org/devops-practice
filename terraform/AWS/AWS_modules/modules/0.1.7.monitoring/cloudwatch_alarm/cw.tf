locals {
  # favor name over alarm name if both are set
  alarm_name             = var.name != "" ? var.name : var.alarm_name
  sp_alarm_config = var.sp_alarms_enabled && var.sp_managed ? "enabled" : "disabled"
  customer_alarm_config  = var.customer_alarms_enabled || false == var.sp_managed ? "enabled" : "disabled"
  customer_ok_config     = var.customer_alarms_cleared && var.customer_alarms_enabled || false == var.sp_managed ? "enabled" : "disabled"

  sp_alarm_actions = {
    enabled  = [local.sp_sns_topic[var.severity]]
    disabled = []
  }

  customer_alarm_actions = {
    enabled  = compact(var.notification_topic)
    disabled = []
  }

  sp_sns_topic = {
    standard  = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:sp-support-standard"
    urgent    = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:sp-support-urgent"
    emergency = "arn:aws:sns:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:sp-support-emergency"
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

resource "aws_cloudwatch_metric_alarm" "alarm" {
  count = var.alarm_count

  alarm_description   = var.alarm_description
  alarm_name          = var.alarm_count > 1 ? format("%v-%03d", local.alarm_name, count.index + 1) : local.alarm_name
  comparison_operator = var.comparison_operator
  dimensions          = var.dimensions[count.index]
  evaluation_periods  = var.evaluation_periods
  metric_name         = var.metric_name
  namespace           = var.namespace
  period              = var.period
  statistic           = var.statistic
  threshold           = var.threshold
  treat_missing_data  = var.treat_missing_data
  unit                = var.unit

  alarm_actions = concat(
    local.sp_alarm_actions[local.sp_alarm_config],
    local.customer_alarm_actions[local.customer_alarm_config],
  )

  ok_actions = concat(
    local.sp_alarm_actions[local.sp_alarm_config],
    local.customer_alarm_actions[local.customer_ok_config],
  )
}