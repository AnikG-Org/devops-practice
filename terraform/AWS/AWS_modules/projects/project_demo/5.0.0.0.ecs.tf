/* #enable when required

locals {
  user_data_base64_ecs = <<EOF
#!/bin/bash
# ECS config
{
  echo "ECS_CLUSTER=${local.ecs_name}"
} >> /etc/ecs/ecs.config
start ecs
echo "Done"
  EOF
  ecs_tags_as_map = merge(
    {
      ,
      Created_Via     = "Terraform IAAC",
      project         = var.project,
      git_repo        = var.git_repo,
      ServiceProvider = var.ServiceProvider,
    },
  )
  ecs_name = "ECS-PRD-ASG"
  create_ecs = true
  create_asg = local.create_ecs == true ? true : false
  container_insights = false
}

#####################  ECS ASG default ############################
module "ecs_asg" {
  source          = "../../modules/0.1.4.compute/asg"
  
  create_asg = local.create_asg

  use_name_prefix           = true
  asg_name                  = "ecs-asg"
  asg_instance_name         = local.ecs_name
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
  service_linked_role_arn   = module.ecs_asg.aws_iam_service_linked_role_arn

  # Launch template
  aws_launch_template_create_lt = local.create_asg
  create_lt_for_asg             = local.create_asg

  lt_name                = "ecs-asg-lt"
  lt_version             = "$Latest"
  description            = "Complete launch template for ECS ASG"
  update_default_version = true

  image_id                 = module.ecs.amazon_linux_ecs_ami_id
  instance_type            = "t3.micro"
  key_name                 = "anik_test"
  user_data_base64         = base64encode(local.user_data_base64_ecs)
  enable_monitoring        = true
  iam_instance_profile_arn = module.ecs.iam_instance_profile_arn
  target_group_arns        = []

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.count_security_groups_6.output_dynamicsg_v2[0]]
    },
  ]
  tag_specifications = [
    {
      resource_type = "volume"
      tags          = merge({ Name = local.ecs_name }, local.ecs_tags_as_map)
    },
  ]
}
#####################  ECS ASG capacity_provider ############################
module "capacity_provider_asg" {
  source          = "../../modules/0.1.4.compute/asg"
  
  create_asg = local.create_asg

  use_name_prefix           = true
  asg_name                  = "ecs-asg-capacity-provider"
  asg_instance_name         = local.ecs_name
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
  service_linked_role_arn   = module.ecs_asg.aws_iam_service_linked_role_arn

  # Launch template
  aws_launch_template_create_lt = local.create_asg
  create_lt_for_asg             = local.create_asg

  lt_name                = "ecs-asg-lt"
  lt_version             = "$Latest"
  description            = "Complete launch template for ECS ASG"
  update_default_version = true

  image_id                 = module.ecs.amazon_linux_ecs_ami_id
  instance_type            = "t3.micro"
  key_name                 = "anik_test"
  user_data_base64         = base64encode(local.user_data_base64_ecs)
  enable_monitoring        = true
  iam_instance_profile_arn = module.ecs.iam_instance_profile_arn
  target_group_arns        = []
  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.count_security_groups_6.output_dynamicsg_v2[0]]
    },
  ]
  tag_specifications = [
    {
      resource_type = "volume"
      tags          = merge({ Name = local.ecs_name }, local.ecs_tags_as_map)
    },
  ]
}
###########################  ECS SG   ###########################
module "count_security_groups_6" {
  source          = "../../modules/0.1.3.security/sg-count-adv"
  
  #tag
  sg2_custom_name01 = "ecs"
  aws_vpc_id        = module.aws_network_1.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "All traffic from 0.0.0.0/0"
      cidr_blocks = "0.0.0.0/0"
    },
  ] 
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo
}
###########################  aws_ecs_capacity_provider   ################################
resource "aws_ecs_capacity_provider" "default_asg" {
  name = "DEFAULT-ASG-ECS"
  auto_scaling_group_provider {
    auto_scaling_group_arn = module.ecs_asg.autoscaling_group_arn
    managed_termination_protection = "DISABLED"
}
}
#--------------------------------------------------------
resource "aws_ecs_capacity_provider" "capacity_provider_asg" {
  name = "ASG-ECS"
  auto_scaling_group_provider {
    auto_scaling_group_arn = module.capacity_provider_asg.autoscaling_group_arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      status                    = "DISABLED"
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      target_capacity           = 10
    }    
  }
}
########################### ECS Cluster ###########################
module "ecs" {
  source          = "../../modules/0.1.4.compute/ecs"
  

  create_ecs         = local.create_ecs
  name               = local.ecs_name
  container_insights = local.create_ecs == true ? local.container_insights : false
  capacity_providers = ["FARGATE", "FARGATE_SPOT", aws_ecs_capacity_provider.default_asg.name, aws_ecs_capacity_provider.capacity_provider_asg.name]

  default_capacity_provider_strategy = [{
    capacity_provider = aws_ecs_capacity_provider.default_asg.name
    weight            = "1"
  }]
  tags = {
    ECS = "UserECSManaged"
  }
}
###########################  ECR   ############################
module "ecr" {
  source       = "../../modules/0.1.4.compute/ecs/ecr"
  
  image_names  = ["ecr"] #["ecr1", "ecr2"]
  scan_images_on_push = true
}
########################## ECS TASK DEF ########################

module "task_definition" {
  source = "../../modules/0.1.4.compute/ecs/ecs-task-definition"
  

  family = "webapp"
#   cpu    = 1
#   memory = 128
  network_mode = "awsvpc"

  container_definitions = [
    {
      name      = "nginx"
      image     = "nginx"
      cpu       = 1
      memory    = 128
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
]

}
########################## ECS SERVICE ########################
module "ecs_service" {
  source = "../../modules/0.1.4.compute/ecs/ecs-service"
  

  service_name    = "nginx-service"
  cluster         = module.ecs.ecs_cluster_arn[0] 
  task_definition = module.task_definition.arn[0] 

  desired_count = 1

  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0

  deployment_circuit_breaker = [{
    enable  = true
    rollback = true
  }]

  network_configuration = [{
    subnets          = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
    security_groups  = [module.count_security_groups_6.output_dynamicsg_v2[0]]
    assign_public_ip = false
  }]
}
########################## ECS SERVICE Auto Scale ####################
module "ecs-service-autoscaling-cloudwatch" {
  source = "../../modules/0.1.4.compute/ecs/ecs-service/ecs-svc-autoscaling-cloudwatch"
  

  enabled = false

  name_prefix = "ecs-sqs-scalling"

  min_capacity = 1
  max_capacity = 10

  cluster_name = module.ecs.ecs_cluster_name[0]
  service_name = module.ecs_service.ecs_service_name[0]

  scale_up_step_adjustment = [
    {
      scaling_adjustment          = 2
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 5
    },
    {
      scaling_adjustment          = 1
      metric_interval_lower_bound = 5
      metric_interval_upper_bound = "" # indicates inifinity
    }
  ]

  scale_down_step_adjustment = [
    {
      scaling_adjustment          = -4
      metric_interval_upper_bound = 0
      metric_interval_lower_bound = ""
    }
  ]
#####  
# CloudWatch Alerts
#####  
  high_evaluation_periods = "2"
  low_evaluation_periods  = "2"

  high_threshold = "90"
  low_threshold  = "10"
  
  metric_query = [
    # {
    #   id          = "e1"
    #   return_data = true
    #   expression  = "visible+notvisible"
    #   label       = "Sum_Visible+NonVisible"
    # },
    # {
    #   id = "visible"
    #   metric = [
    #     {
    #       namespace   = "AWS/SQS"
    #       metric_name = "ApproximateNumberOfMessagesVisible"
    #       period      = 60
    #       stat        = "Maximum"

    #       dimensions = {
    #         QueueName = "sqs_name" #aws_sqs_queue.queue.name
    #       }
    #     }
    #   ]
    # },
    # {
    #   id = "notvisible"

    #   metric = [
    #     {
    #       namespace   = "AWS/SQS"
    #       metric_name = "ApproximateNumberOfMessagesNotVisible"
    #       period      = 60
    #       stat        = "Maximum"

    #       dimensions = {
    #         QueueName = "sqs_name"
    #       }
    #     }
    #   ]
    # },
    {
      id          = "m1"
      return_data = true
      expression  = "cpuutilization"
      label       = "Sum_CPUUtilization"
    },    
    {
      id = "cpuutilization"  
      metric = [
        {  
          namespace   = "AWS/ECS"
          metric_name = "CPUUtilization"
          period      = 120
          stat        = "Average"
          unit        = "Count"

          dimensions = {
            ClusterName = module.ecs.ecs_cluster_name[0]
          }
        }
      ]
    }
  ]
}
##############################################################################

*/