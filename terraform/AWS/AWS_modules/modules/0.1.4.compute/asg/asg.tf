# Autoscaling group
################################################################################

resource "aws_autoscaling_group" "this" {
  count = var.create_asg ? 1 : 0

  name        = var.use_name_prefix ? null : var.asg_name
  name_prefix = var.use_name_prefix ? "${var.asg_name}-" : null

  launch_configuration = var.use_lc ? var.launch_configuration : null #"Name of an existing launch configuration to be used (created outside of this module)"

  dynamic "launch_template" {
    for_each = var.use_lt ? [1] : []

    content {
      name    = var.create_lt_for_asg ? aws_launch_template.this[0].name : var.launch_template #var.launch_template >> Name of an existing launch template to be used (created outside of this module)"
      version = var.lt_version
    }
  }

  availability_zones  = var.availability_zone
  vpc_zone_identifier = var.vpc_zone_identifier

  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  capacity_rebalance        = var.capacity_rebalance
  min_elb_capacity          = var.min_elb_capacity
  wait_for_elb_capacity     = var.wait_for_elb_capacity
  wait_for_capacity_timeout = var.wait_for_capacity_timeout
  default_cooldown          = var.default_cooldown
  protect_from_scale_in     = var.protect_from_scale_in

  load_balancers            = var.load_balancers
  target_group_arns         = var.target_group_arns
  placement_group           = var.placement_group
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period

  force_delete          = var.force_delete
  termination_policies  = var.termination_policies
  suspended_processes   = var.suspended_processes
  max_instance_lifetime = var.max_instance_lifetime

  enabled_metrics         = var.enabled_metrics
  metrics_granularity     = var.metrics_granularity
  service_linked_role_arn = var.service_linked_role_arn

  dynamic "initial_lifecycle_hook" {
    for_each = var.initial_lifecycle_hooks
    content {
      name                    = initial_lifecycle_hook.value.name
      default_result          = lookup(initial_lifecycle_hook.value, "default_result", null)
      heartbeat_timeout       = lookup(initial_lifecycle_hook.value, "heartbeat_timeout", null)
      lifecycle_transition    = initial_lifecycle_hook.value.lifecycle_transition
      notification_metadata   = lookup(initial_lifecycle_hook.value, "notification_metadata", null)
      notification_target_arn = lookup(initial_lifecycle_hook.value, "notification_target_arn", null)
      role_arn                = lookup(initial_lifecycle_hook.value, "role_arn", null)
    }
  }

  dynamic "instance_refresh" {
    for_each = var.instance_refresh != null ? [var.instance_refresh] : []
    content {
      strategy = instance_refresh.value.strategy
      triggers = lookup(instance_refresh.value, "triggers", null)

      dynamic "preferences" {
        for_each = lookup(instance_refresh.value, "preferences", null) != null ? [instance_refresh.value.preferences] : []
        content {
          instance_warmup        = lookup(preferences.value, "instance_warmup", null)
          min_healthy_percentage = lookup(preferences.value, "min_healthy_percentage", null)
        }
      }
    }
  }

  dynamic "mixed_instances_policy" {
    for_each = var.use_mixed_instances_policy ? [var.mixed_instances_policy] : []
    content {
      dynamic "instances_distribution" {
        for_each = lookup(mixed_instances_policy.value, "instances_distribution", null) != null ? [mixed_instances_policy.value.instances_distribution] : []
        content {
          on_demand_allocation_strategy            = lookup(instances_distribution.value, "on_demand_allocation_strategy", null)
          on_demand_base_capacity                  = lookup(instances_distribution.value, "on_demand_base_capacity", null)
          on_demand_percentage_above_base_capacity = lookup(instances_distribution.value, "on_demand_percentage_above_base_capacity", null)
          spot_allocation_strategy                 = lookup(instances_distribution.value, "spot_allocation_strategy", null)
          spot_instance_pools                      = lookup(instances_distribution.value, "spot_instance_pools", null)
          spot_max_price                           = lookup(instances_distribution.value, "spot_max_price", null)
        }
      }

      launch_template {
        launch_template_specification {
          launch_template_name = var.create_lt_for_asg ? aws_launch_template.this[0].name : var.launch_template
          version              = var.lt_version
        }

        dynamic "override" {
          for_each = lookup(mixed_instances_policy.value, "override", null) != null ? mixed_instances_policy.value.override : []
          content {
            instance_type     = lookup(override.value, "instance_type", null)
            weighted_capacity = lookup(override.value, "weighted_capacity", null)

            dynamic "launch_template_specification" {
              for_each = lookup(override.value, "launch_template_specification", null) != null ? override.value.launch_template_specification : []
              content {
                launch_template_id = lookup(launch_template_specification.value, "launch_template_id", null)
              }
            }
          }
        }
      }
    }
  }

  timeouts {
    delete = var.delete_timeout
  }

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}
resource "random_string" "name" {
  length  = "10"
  special = false
  number  = true
  upper   = false
}
locals {
  random_name = random_string.name.result
}
resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "iam-asg-${local.random_name}"
  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}
