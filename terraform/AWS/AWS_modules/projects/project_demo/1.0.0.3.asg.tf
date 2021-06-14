locals {
  user_data_base64_1 = <<EOF
  #!/bin/bash
  echo "Hello Terraform! $(date +'%d/%m/%Y')" > op.txt
  apt update -y
  apt install nginx -y
  systemctl enable nginx
  systemctl start nginx
  EOF
  tags_as_map = merge(
    {
      environment     = var.environment,
      Created_Via     = "Terraform IAAC",
      project         = var.project,
      git_repo        = var.git_repo,
      ServiceProvider = var.ServiceProvider,

    },
  )
  asg_instance_name = "NGX-ASG-PRD"
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "iam-asg"
  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}


module "asg_1" {
  source = "../../modules/0.1.4.compute/asg"

  ################################################################################
  # common tag
  ################################################################################
  environment     = var.environment
  project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################  
  create_asg = false

  use_name_prefix           = true
  asg_name                  = "asg-tf"
  asg_instance_name         = local.asg_instance_name #"NGX-ASG-PRD"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  initial_lifecycle_hooks = [
    {
      name                 = "ExampleStartupLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 60
      lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                 = "ExampleTerminationLifeCycleHook"
      default_result       = "CONTINUE"
      heartbeat_timeout    = 180
      lifecycle_transition = "autoscaling:EC2_INSTANCE_TERMINATING"
      # This could be a rendered data resource
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  # Launch template
  aws_launch_template_create_lt = false
  use_lt                        = true
  create_lt_for_asg             = false

  lt_name                = "asg-lt"
  lt_version             = "$Latest"
  description            = "Complete launch template for ASG"
  update_default_version = true


  image_id                 = module.asg_1.ami_linux.ubuntu_ami
  instance_type            = "t3.micro"
  user_data_base64         = base64encode(local.user_data_base64_1)
  ebs_optimized            = false
  enable_monitoring        = true
  iam_instance_profile_arn = module.ec2_iam_admin_role.ec2_admin_iam_role_arn
  target_group_arns        = []

  block_device_mappings = [
    {                           # Root Block
      device_name = "/dev/sda1" # name "/dev/sda1" default for root
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = false
        volume_size           = 9
        volume_type           = "gp3"
      }
    }, # Additional block
    # { 
    #   device_name = "/dev/sdd"
    #   no_device   = 1
    #   ebs = {
    #     delete_on_termination = true
    #     encrypted             = false
    #     volume_size           = 8
    #     volume_type           = "gp2"
    #   }
    # }
  ]
  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = [module.security_groups_1.output_dynamicsg_1]
    },
    # {
    #   delete_on_termination = true
    #   description           = "eth1"
    #   device_index          = 1
    #   security_groups       = [module.security_groups_1.security_group_id]
    # }
  ]
  tag_specifications = [
    # {
    #   resource_type = "instance"
    #   tags          = merge({ Name = local.asg_instance_name }, local.tags_as_map)
    # },
    {
      resource_type = "volume"
      tags          = merge({ Name = local.asg_instance_name }, local.tags_as_map)
    },
  ]
}
###########################
