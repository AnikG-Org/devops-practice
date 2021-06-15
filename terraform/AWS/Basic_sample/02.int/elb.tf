#alb on AWS
# Create a new load balancer
resource "aws_lb" "application_alb" {
  name                             = "application-elb"
  internal                         = false
  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = false
  load_balancer_type               = "application"
  security_groups                  = ["${aws_security_group.lb_sg.id}"]
  #subnets            = aws_subnet.public.*.id
  subnets = var.elb_pub_subnet

  access_logs {
    bucket  = aws_s3_bucket.mys3.id
    prefix  = "log/log-elb"
    enabled = false
  }

  tags = {
    Name         = "elb-${var.myec2tagname["Name"]}-01"
    created_from = "TF"
    created_by   = var.myec2tagname["created_by"]
    timestamp    = "${timestamp()}"
  }
}
#lb rules
resource "aws_lb_listener" "front_end_80" {
  load_balancer_arn = aws_lb.application_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "front_end_443" {
  load_balancer_arn = aws_lb.application_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:acm:ap-south-1:388891221585:certificate/99be46cf-c425-4e37-b275-20519a56f685"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_1.arn
  }
}

#static route 
resource "aws_lb_listener_rule" "static" {
  listener_arn = aws_lb_listener.front_end_443.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_1.arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}
/*
# Forward action

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = aws_lb_listener.front_end_443.arn
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg_1.arn
  }

  condition {
    host_header {
      values = ["*.test.com"]
    }
  }
}
# Weighted Forward action

resource "aws_lb_listener_rule" "host_based_routing" {
  listener_arn = aws_lb_listener.front_end_443.arn
  priority     = 99

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.lb_tg_1.arn
        weight = 80
      }

      target_group {
        arn    = aws_lb_target_group.lb_tg_1.arn
        weight = 20
      }

      stickiness {
        enabled  = true
        duration = 600
      }
    }
  condition {
    host_header {
      values = ["*.test.com"]
    }
  }
}
*/


#target_group
resource "aws_lb_target_group" "lb_tg_1" {
  name                 = "elb-${var.myec2tagname["Name"]}-tg-01"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.myec2_vpc_id
  deregistration_delay = "300"
  stickiness {
    type    = "lb_cookie"
    enabled = false
  }
  tags = {
    created_from = "TF"
    created_by   = var.myec2tagname["created_by"]
    timestamp    = "${timestamp()}"
  }
}