#/*  Count index for ec2
resource "aws_instance" "myec2_count" {
  count                       = var.instance_count_sequence
  ami                         = var.myec2ami[var.region]
  availability_zone           = var.ec2_az
  instance_type               = var.myec2_instancetype
  iam_instance_profile        = aws_iam_instance_profile.myec2role_profile_01.name
  subnet_id                   = var.myec2_subnet_id
  key_name                    = var.instance_key
  monitoring                  = true
  associate_public_ip_address = true
  user_data_base64            = base64encode(local.user_data_count)
  security_groups             = ["${aws_security_group.count_ec2_sg.id}"]
  root_block_device {
    volume_type           = var.root_block_device_type
    volume_size           = var.root_block_device_size
    encrypted             = var.root_block_device_encryption
    delete_on_termination = var.root_block_device_delete_on_termination
    tags = {
      Name              = "${var.myec2tagname["Name"]}-root-block-${count.index}"
      created_from      = "TF"
      created_by        = var.myec2tagname["created_by"]
      timestamp         = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
      instance_sequence = "${count.index}"
    }
  }

  tags = {
    Name              = format("web-%03d", count.index + 1)
    created_from      = "TF"
    created_by        = var.myec2tagname["created_by"]
    timestamp         = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    instance_sequence = "${count.index}"
  }
}


#*/