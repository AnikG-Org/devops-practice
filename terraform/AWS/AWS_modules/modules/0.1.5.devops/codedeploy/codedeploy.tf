locals {
  application_name = element(
    concat(
      aws_codedeploy_app.application.*.name,
      [var.application_name],
    ),
    0,
  )
  default_deployment_group_name = "${var.application_name}-${var.deployment_environment}"
  deployment_group_name         = var.deployment_group_name == "" ? local.default_deployment_group_name : var.deployment_group_name

  ec2_tag_filters = {
    key   = var.ec2_tag_key
    type  = "KEY_AND_VALUE"
    value = var.ec2_tag_value

  }

  enable_trafic_control = var.clb_name != "" || var.target_group_name != ""
}
#-----------------------------------------------------------------------
resource "aws_codedeploy_app" "application" {
  count = var.create_application ? 1 : 0

  name             = var.application_name
  compute_platform = var.compute_platform
}
#-----------------------------------------------------------------------
# "CODEDEPLOY"
data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role" {
  name_prefix        = "${local.deployment_group_name}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "code_deploy_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.role.name
}
#-----------------------------------------------------------------------
# "CODEDEPLOY-ECS"
data "aws_iam_policy_document" "assume_role_policy_1" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "role_1" {
  name_prefix        = "${local.deployment_group_name}-"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy_1.json
}

resource "aws_iam_role_policy_attachment" "code_deploy_policy_attachment_1" {
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS" #AWSCodeDeployRoleForECS
  role       = aws_iam_role.role_1.name
}
#-----------------------------------------------------------------------
resource "aws_codedeploy_deployment_group" "deployment_group" {
  count = var.compute_platform != "ECS" ? 1 : 0

  app_name               = local.application_name
  autoscaling_groups     = var.autoscaling_groups
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = local.deployment_group_name

  dynamic "ec2_tag_filter" {
    for_each = var.ec2_tag_key != "" && var.ec2_tag_value != "" ? [local.ec2_tag_filters] : []
    content {
      key   = lookup(ec2_tag_filter.value, "key", null)
      type  = lookup(ec2_tag_filter.value, "type", null)
      value = lookup(ec2_tag_filter.value, "value", null)
    }
  }
  service_role_arn = aws_iam_role.role.arn

  auto_rollback_configuration {
    enabled = var.enable_auto_rollback_configuration
    events  = ["DEPLOYMENT_FAILURE"]
  }
  deployment_style {
    deployment_option = local.enable_trafic_control ? "WITH_TRAFFIC_CONTROL" : "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = var.enable_bluegreen == false ? "IN_PLACE" : "BLUE_GREEN"
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.enable_bluegreen == true ? [1] : []
    content {
      deployment_ready_option {
        action_on_timeout    = var.bluegreen_timeout_action
        wait_time_in_minutes = var.wait_time_in_minutes
      }

      terminate_blue_instances_on_deployment_success {
        action = var.blue_termination_behavior
      }
      green_fleet_provisioning_option {
        action = var.green_provisioning
      }
    }
  }

  dynamic "trigger_configuration" {
    for_each = var.trigger_target_arn == null ? [] : [var.trigger_target_arn]
    content {
      trigger_events     = var.trigger_events
      trigger_name       = "${var.application_name}-${var.deployment_environment}"
      trigger_target_arn = var.trigger_target_arn
    }
  }

  load_balancer_info {
    dynamic "elb_info" {
      for_each = var.clb_name == "" ? [] : [var.clb_name]
      content {
        name = elb_info.value
      }
    }

    dynamic "target_group_info" {
      for_each = var.target_group_name == "" ? [] : [var.target_group_name]
      content {
        name = target_group_info.value
      }
    }
  }
}
#-----------------------------------------------------------------------
#-----------------------------------------------------------------------

resource "aws_codedeploy_deployment_group" "ecs_deployment_group" {
  count = var.compute_platform == "ECS" ? 1 : 0

  app_name               = local.application_name
  autoscaling_groups     = var.autoscaling_groups
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = local.deployment_group_name

  dynamic "ec2_tag_filter" {
    for_each = var.ec2_tag_key != "" && var.ec2_tag_value != "" ? [local.ec2_tag_filters] : []
    content {
      key   = lookup(ec2_tag_filter.value, "key", null)
      type  = lookup(ec2_tag_filter.value, "type", null)
      value = lookup(ec2_tag_filter.value, "value", null)
    }
  }
  service_role_arn = aws_iam_role.role_1.arn

  auto_rollback_configuration {
    enabled = var.enable_auto_rollback_configuration
    events  = ["DEPLOYMENT_FAILURE"]
  }
  deployment_style {
    deployment_option = local.enable_trafic_control ? "WITHOUT_TRAFFIC_CONTROL" : "WITH_TRAFFIC_CONTROL"
    deployment_type   = var.enable_bluegreen == false ? "IN_PLACE" : "BLUE_GREEN"
  }
  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }
  dynamic "blue_green_deployment_config" {
    for_each = var.enable_bluegreen == true ? [1] : []
    content {
      deployment_ready_option {
        action_on_timeout = var.bluegreen_timeout_action
      }

      terminate_blue_instances_on_deployment_success {
        action                           = var.blue_termination_behavior
        termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
      }
      green_fleet_provisioning_option {
        action = var.green_provisioning
      }
    }
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.lb_listener_arns
      }

      dynamic "test_traffic_route" {
        for_each = var.test_traffic_route == true ? [1] : []
        content {
          listener_arns = var.test_traffic_route_listener_arns
        }
      }
      # test_traffic_route {
      #   listener_arns = [var.test_traffic_route_listener_arns] #(OPTIONAL)
      # }      
      target_group {
        name = var.blue_lb_target_group_name
      }
      target_group {
        name = var.green_lb_target_group_name
      }
    }
  }

  dynamic "trigger_configuration" {
    for_each = var.trigger_target_arn == null ? [] : [var.trigger_target_arn]
    content {
      trigger_events     = var.trigger_events
      trigger_name       = "${var.application_name}-${var.deployment_environment}"
      trigger_target_arn = var.trigger_target_arn
    }
  }

}
###########################################
