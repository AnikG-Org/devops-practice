resource "random_string" "name" {
  length  = "10"
  special = false
  number  = true
  upper   = false
}
locals {
  random_name = random_string.name.result
}
#####
# Autoscaling Target
#####
resource "aws_appautoscaling_target" "target" {
  count = var.enabled ? 1 : 0

  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_capacity
  max_capacity       = var.max_capacity
  service_namespace  = "ecs"
}

#####
# Autoscaling Policies
#####
resource "aws_appautoscaling_policy" "scale_up" {
  count = var.enabled ? 1 : 0

  name               = "${var.name_prefix}-scale-up-${local.random_name}"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    cooldown                 = var.scale_up_cooldown
    adjustment_type          = var.adjustment_type_up
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = var.scale_up_min_adjustment_magnitude

    dynamic "step_adjustment" {
      for_each = var.scale_up_step_adjustment
      content {
        metric_interval_lower_bound = lookup(step_adjustment.value, "metric_interval_lower_bound")
        metric_interval_upper_bound = lookup(step_adjustment.value, "metric_interval_upper_bound")
        scaling_adjustment          = lookup(step_adjustment.value, "scaling_adjustment")
      }
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

resource "aws_appautoscaling_policy" "scale_down" {
  count = var.enabled ? 1 : 0

  name               = "${var.name_prefix}-scale-down-${local.random_name}"
  policy_type        = "StepScaling"
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  step_scaling_policy_configuration {
    cooldown                 = var.scale_down_cooldown
    adjustment_type          = var.adjustment_type_down
    metric_aggregation_type  = "Average"
    min_adjustment_magnitude = var.scale_down_min_adjustment_magnitude

    dynamic "step_adjustment" {
      for_each = var.scale_down_step_adjustment
      content {
        metric_interval_lower_bound = lookup(step_adjustment.value, "metric_interval_lower_bound")
        metric_interval_upper_bound = lookup(step_adjustment.value, "metric_interval_upper_bound")
        scaling_adjustment          = lookup(step_adjustment.value, "scaling_adjustment")
      }
    }
  }

  depends_on = [aws_appautoscaling_target.target]
}

#####
# CloudWatch Alerts
#####

resource "aws_cloudwatch_metric_alarm" "high" {
  count = var.enabled ? 1 : 0

  alarm_name          = "${var.name_prefix}-alarm-high-${local.random_name}"
  alarm_description   = "Alarm monitors high utilization for scaling up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = var.high_evaluation_periods
  threshold           = var.high_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_up[0].arn]

  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      expression  = lookup(metric_query.value, "expression", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
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

  depends_on = [aws_appautoscaling_policy.scale_up]
}

resource "aws_cloudwatch_metric_alarm" "low" {
  count = var.enabled ? 1 : 0

  alarm_name          = "${var.name_prefix}-alarm-low-${local.random_name}"
  alarm_description   = "Alarm monitors low utilization for scaling down."
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = var.low_evaluation_periods
  threshold           = var.low_threshold
  alarm_actions       = [aws_appautoscaling_policy.scale_down[0].arn]

  dynamic "metric_query" {
    for_each = var.metric_query
    content {
      id          = lookup(metric_query.value, "id")
      label       = lookup(metric_query.value, "label", null)
      return_data = lookup(metric_query.value, "return_data", null)
      expression  = lookup(metric_query.value, "expression", null)

      dynamic "metric" {
        for_each = lookup(metric_query.value, "metric", [])
        content {
          metric_name = lookup(metric.value, "metric_name")
          namespace   = lookup(metric.value, "namespace")
          period      = lookup(metric.value, "period")
          stat        = lookup(metric.value, "stat")
          unit        = lookup(metric.value, "unit", null)
          dimensions  = lookup(metric.value, "dimensions", null)
        }
      }
    }
  }

  tags = var.tags

  depends_on = [aws_appautoscaling_policy.scale_down]
}