resource "aws_launch_template" "application_template" {
  name_prefix   = "app-instance"
  description   =   "app template for asg"
  image_id      = var.myec2ami[var.region]
  instance_type = "t3.large"
  key_name = var.instance_key
  instance_initiated_shutdown_behavior = "terminate"
  #vpc_security_group_ids = ["${aws_security_group.myec2sg_01.id}"]
  network_interfaces { 
      associate_public_ip_address = false 
      security_groups = ["${aws_security_group.myec2sg_01.id}"]
      } 
/*  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 9
      volume_type = "gp3"
      delete_on_termination = true
    } 
  } */

  iam_instance_profile {
    name = aws_iam_instance_profile.myec2role_profile_01.name
  }
  capacity_reservation_specification { capacity_reservation_preference = "open" }
  monitoring { enabled = true }  
  user_data = filebase64("/asg_userdata.sh")
}


#asg
resource "aws_autoscaling_group" "application_asg_01" {
  #availability_zones = var.ec2_autoscale_az
  vpc_zone_identifier  = [var.pvt_subnet[0], var.pvt_subnet[1]]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  termination_policies = ["OldestInstance"]
  health_check_type    = "EC2"
  #load_balancers = [aws_lb.application_alb.id]
  lifecycle {
    create_before_destroy = true
  }
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.application_template.id
        version = "$Latest"
      }
    }
  }
  tag {
    key                 = "Name"
    value               = "${var.myec2tagname["Name"]}-asg"
    propagate_at_launch = true
    /*      
    Name = "${var.myec2tagname["Name"]}-asg"
    created_from = "TF"
    timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp())) */
  }
}

/*
resource "aws_autoscaling_notification" "asg_notifications" {
  group_names = [
    aws_autoscaling_group.application_asg_01.name
  ]

  notifications = [
    #"autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.example.arn
}*/
resource "aws_autoscaling_lifecycle_hook" "asg_lifecycle_hook" {
  name                   = "asg_lifecycle_hook"
  autoscaling_group_name = aws_autoscaling_group.application_asg_01.name
  default_result         = "CONTINUE"
  heartbeat_timeout      = 2000
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_LAUNCHING"

  notification_metadata = <<EOF
{
  "EC2_INSTANCE_LAUNCHING": "ERROR"
}
EOF
/*
  notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
  role_arn                = "arn:aws:iam::123456789012:role/S3Access"
*/
}