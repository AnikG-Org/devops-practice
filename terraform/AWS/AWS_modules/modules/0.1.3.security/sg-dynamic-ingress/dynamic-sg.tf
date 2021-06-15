resource "aws_security_group" "dynamicsg_1" {
  name                   = var.sg_custom_name01
  description            = "Ingress for Vault"
  vpc_id                 = var.aws_vpc_id
  revoke_rules_on_delete = true
  tags = merge(
    {
      Name            = "${var.project}-${var.sg_custom_name01}",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
  lifecycle {
    create_before_destroy = true
  }


  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = ports

    content {
      from_port        = ports.value
      to_port          = ports.value
      protocol         = var.dynamicsg_protocol
      cidr_blocks      = var.dynamicsg_cidr_block_1
      security_groups  = var.dynamicsg_security_groups
      ipv6_cidr_blocks = var.dynamicsg_ipv6_cidr_blocks
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}


