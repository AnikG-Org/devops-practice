#resource assoiciation created by tf

#ELB TG attach
resource "aws_lb_target_group_attachment" "lb_tg" {
  target_group_arn = aws_lb_target_group.lb_tg_1.arn
  count            = var.instance_count_sequence
  target_id        = element(aws_instance.myec2_count.*.id, count.index)
  port             = 80
}
/*
resource "aws_lb_target_group_attachment" "lb_autoscale_tg" {
  target_group_arn = aws_lb_target_group.lb_autoscale_tg_1.arn
  target_id        = aws_autoscaling_group.application_asg_01.id
  port             = 80
}*/
#/*
#asg
resource "aws_autoscaling_attachment" "application_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.application_asg_01.id
  alb_target_group_arn   = aws_lb_target_group.lb_autoscale_tg_1.arn
}
#*/
#network 
/*
resource "aws_network_interface_sg_attachment" "sg_attachment_myec2" {
  security_group_id    = aws_security_group.myec2sg_01.id
  #network_interface_id = aws_instance.myec2.primary_network_interface_id  
  count = var.instance_count_sequence
  network_interface_id = element(aws_instance.myec2_count.*.primary_network_interface_id, count.index)
}*/

#security
resource "aws_iam_role_policy_attachment" "myec2-role-attach_01" {
  role       = aws_iam_role.myec2role_01.name
  policy_arn = aws_iam_policy.myec2_admin_policy_01.arn
}
resource "aws_iam_instance_profile" "myec2role_profile_01" {
  name = "myec2role_profile_01"
  role = aws_iam_role.myec2role_01.name
}