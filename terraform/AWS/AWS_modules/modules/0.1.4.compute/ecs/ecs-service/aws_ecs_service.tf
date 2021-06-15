resource "aws_ecs_service" "service" {
  count = var.enable_service ? 1 : 0

  name            = var.service_name
  task_definition = var.task_definition
  cluster         = var.cluster

  desired_count                      = var.desired_count
  iam_role                           = var.iam_role
  scheduling_strategy                = var.scheduling_strategy
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  dynamic "deployment_circuit_breaker" {
    for_each = var.deployment_circuit_breaker
    content {
      enable   = lookup(deployment_circuit_breaker.value, "enable", null)
      rollback = lookup(deployment_circuit_breaker.value, "rollback", null)
    }
  }
  dynamic "ordered_placement_strategy" {
    for_each = var.ordered_placement_strategy
    content {
      type  = lookup(ordered_placement_strategy.value, "type", null)
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration
    content {
      subnets          = lookup(network_configuration.value, "subnets", null)
      security_groups  = lookup(network_configuration.value, "security_groups", null)
      assign_public_ip = lookup(network_configuration.value, "assign_public_ip", null)
    }
  }

  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  dynamic "load_balancer" {
    for_each = var.load_balancer
    content {
      elb_name         = lookup(load_balancer.value, "elb_name", null)
      target_group_arn = lookup(load_balancer.value, "target_group_arn", null)
      container_name   = lookup(load_balancer.value, "container_name", null)
      container_port   = lookup(load_balancer.value, "container_port", null)
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      type       = lookup(placement_constraints.value, "type", null)
      expression = lookup(placement_constraints.value, "expression", null)
    }
  }

  dynamic "deployment_controller" {
    for_each = var.deployment_controller
    content {
      type = lookup(deployment_controller.value, "type", null)
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
}