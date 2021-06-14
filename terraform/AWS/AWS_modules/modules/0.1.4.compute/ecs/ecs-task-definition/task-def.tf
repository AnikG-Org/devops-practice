resource "aws_ecs_task_definition" "service" {
  count                 = var.enable_task_definition ? 1 : 0
  container_definitions = jsonencode(var.container_definitions)
  requires_compatibilities = var.requires_compatibilities
  task_role_arn            = var.task_role_arn

  execution_role_arn    = var.execution_role_arn
  family                = var.family
  ipc_mode              = var.ipc_mode
  network_mode          = var.network_mode
  pid_mode              = var.pid_mode

  # Fargate requires cpu and memory to be defined at the task level
  cpu    = var.cpu
  memory = var.memory

  dynamic "volume" {
    for_each = var.volumes
    content {
      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name
      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }
      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory = lookup(efs_volume_configuration.value, "root_directory", null)
        }
      }
    }
  }
  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = lookup(placement_constraints.value, "expression", null)
      type       = lookup(placement_constraints.value.type, "type", null)
    }
  }
  dynamic "proxy_configuration" {
    for_each = var.proxy_configuration
    content {
      properties           = lookup(proxy_configuration.value, "properties", null)
      type                 = lookup(proxy_configuration.value.type, "type", null)
      container_name       = lookup(proxy_configuration.value.type, "container_name", null)
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
