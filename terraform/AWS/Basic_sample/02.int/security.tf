resource "aws_security_group" "myec2sg" {
  name        = "myec2sg"
  description = "Allow TLS inbound traffic"
  #vpc_id      = aws_vpc.main.id
  vpc_id = var.myec2_vpc_id
  tags = {
    Name = "myec2sg"
    created_from = "TF"
  }
  ingress {
    description      = "ingress from EIP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["${aws_eip.lb.public_ip}/32"]
  }
  ingress {
    description      = "ingress from CIDR"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = var.myec2sgcidr
  }
  ingress {
    description      = "ingress from lb_sg"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.lb_sg.id}"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "lb_sg" {
  name        = "myec2_elb_sg"
  description = "Allow TLS inbound traffic"
  vpc_id = var.myec2_vpc_id
  tags = {
    Name = "myec2sg"
    created_from = "TF"
  }
  ingress {
    description      = "ingress from CIDR"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.myec2sgcidr
  }
  ingress {
    description      = "ingress from CIDR"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.myec2sgcidr
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


resource "aws_security_group" "count_ec2_sg" {
  name        = "count_ec2_sg"
  description = "Allow inbound traffic"
  vpc_id = var.myec2_vpc_id
  tags = {
    Name = "ec2_count_sg"
    created_from = "TF"
  }
  ingress {
    description      = "ingress from CIDR"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = var.myec2sgcidr
  }
  ingress {
    description      = "ingress from CIDR"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = var.myec2sgcidr
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
