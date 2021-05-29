resource "aws_security_group" "myec2sg" {
  name        = "myec2sg"
  description = "Allow TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id
  vpc_id = "vpc-002a0df2fc12ee47a"
  tags = {
    Name = "myec2sg"
    created_from = "TF"
  }
  ingress {
    description      = "ingress from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${aws_eip.lb.public_ip}/32","0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#---------IAM-------
resource "aws_iam_role" "myec2role" {
  name = "ec2-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "myec2_admin_policy" {
  name        = "ec2_admin_policy"
  description = "ec2_admin_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "myec2role_profile" {
  name  = "myec2role_profile"
  role = aws_iam_role.myec2role.name
}
