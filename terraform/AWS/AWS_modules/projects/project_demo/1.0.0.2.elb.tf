#/*
#####################################
#ALB
#####################################
module "alb" {
  source = "../../modules/0.1.6.network/elb"


  create_lb          = false
  name               = "project-1-alb"
  load_balancer_type = "application"
  # access_logs     = { bucket = aws_s3_bucket.s3_bucket_id }
  vpc_id          = module.aws_network_1.vpc_id
  security_groups = [module.security_groups_1.output_dynamicsg_1]
  subnets         = [module.aws_network_1.public_subnet_ids[0], module.aws_network_1.public_subnet_ids[1]]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      },
    }
  ]
  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:acm:ap-south-1:388891221585:certificate/99be46cf-c425-4e37-b275-20519a56f685"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name                 = "Default-tg"
      backend_protocol     = "HTTP"
      backend_port         = 80
      target_type          = "instance"
      deregistration_delay = 10

      stickiness = {
        enabled         = false
        cookie_duration = "86400"
        type            = "lb_cookie"
      }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
      protocol_version = "HTTP1"
      targets = {
        # my_ec2 = {
        #   target_id = module.ec2_count_autorecovery.ec2_instance_id[0]
        #   port      = 80
        # },
        # my_ec2_again = {
        #   target_id = aws_instance.random_name.id
        #   port      = 80
        # }
      }
      tags = {
        InstanceTargetGroupTag = "Default"
      }
    },
  ]
  #common_tag
  environment = var.environment
  project     = var.project
  git_repo    = var.git_repo

  #tags = { timestamp     = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp())) }
}

output "elb_dns" {
  value = module.alb[*].lb_dns_name
}
#*/
