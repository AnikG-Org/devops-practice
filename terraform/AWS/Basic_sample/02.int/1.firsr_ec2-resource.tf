
resource "aws_instance" "myec2" {
  ami                         = var.myec2ami[var.region]
  availability_zone           = var.ec2_az
  instance_type               = var.myec2_instancetype
  iam_instance_profile        = aws_iam_instance_profile.myec2role_profile.name
  subnet_id                   = var.myec2_subnet_id
  key_name                    = var.instance_key
  monitoring                  = true
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.user_data)
  security_groups             = ["${aws_security_group.myec2sg.id}"]
  root_block_device {
    volume_type           = var.root_block_device_type
    volume_size           = var.root_block_device_size
    encrypted             = var.root_block_device_encryption
    delete_on_termination = var.root_block_device_delete_on_termination
    tags = {
      Name         = "${var.myec2tagname["Name"]}-root-block-01"
      created_from = "TF"
      created_by   = var.myec2tagname["created_by"]
      timestamp    = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    }
  }

  tags = {
    Name         = "${var.myec2tagname["Name"]}-01"
    created_from = "TF"
    created_by   = var.myec2tagname["created_by"]
    timestamp    = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
  }
}

locals {
  user_data = <<EOF
#!/bin/bash

echo "Hello Terraform! $(date +'%d/%m/%Y')"
yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx
EOF
}

resource "aws_eip" "lb" {
  vpc = true
  tags = {
    Name         = "${var.myec2tagname["Name"]}-eip"
    created_from = "TF"
    timestamp    = "${timestamp()}"
  }
}


