resource "aws_security_group" "dynamicsg_2" {
  name                   = var.sg2_custom_name01
  count                  = var.count_dynamicsg_2
  description            = "Ingress for Vault"
  vpc_id                 = var.aws_vpc_id
  revoke_rules_on_delete = true
  tags = merge(
    {
      Name            = "${var.project}-${var.sg2_custom_name01}-${count.index + 1}",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )

  ingress = var.ingress

  lifecycle {
    create_before_destroy = true
  }


  egress {
    description      = "All egress traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
