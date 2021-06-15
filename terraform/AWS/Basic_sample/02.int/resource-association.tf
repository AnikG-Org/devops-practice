#resource assoiciation created by tf
#storage

resource "aws_volume_attachment" "ebsasso_myec2_vol1" {
  device_name = "/dev/sdc"
  volume_id   = aws_ebs_volume.myec2ebs_additional.id
  instance_id = aws_instance.myec2.id
}
resource "aws_volume_attachment" "ebsasso_myec2_vol2" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.myec2ebs_backup.id
  instance_id = aws_instance.myec2.id
}
#ELB TG attach
resource "aws_lb_target_group_attachment" "lb_tg" {
  target_group_arn = aws_lb_target_group.lb_tg_1.arn
  target_id        = aws_instance.myec2.id
  port             = 80
}

#/*
#asg

#*/
#network 
/*
resource "aws_network_interface_sg_attachment" "sg_attachment_myec2" {
  security_group_id    = aws_security_group.myec2sg.id
  network_interface_id = aws_instance.myec2.primary_network_interface_id  
}*/

resource "aws_eip_association" "eipass_myec2" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}

#security
resource "aws_iam_role_policy_attachment" "myec2-role-attach" {
  role       = aws_iam_role.myec2role.name
  policy_arn = aws_iam_policy.myec2_admin_policy.arn
}
resource "aws_iam_instance_profile" "myec2role_profile" {
  name = "myec2role_profile"
  role = aws_iam_role.myec2role.name
}