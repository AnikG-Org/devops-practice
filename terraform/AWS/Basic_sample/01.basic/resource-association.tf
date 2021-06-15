#resource assoiciation created by tf
resource "aws_eip_association" "eipass_myec2" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}

resource "aws_volume_attachment" "ebsasso_myec2" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.myec2ebs.id
  instance_id = aws_instance.myec2.id
}

resource "aws_network_interface_sg_attachment" "sg_attachment_myec2" {
  security_group_id    = aws_security_group.myec2sg.id
  network_interface_id = aws_instance.myec2.primary_network_interface_id
}

resource "aws_iam_role_policy_attachment" "myec2-role-attach" {
  role       = aws_iam_role.myec2role.name
  policy_arn = aws_iam_policy.myec2_admin_policy.arn
}
