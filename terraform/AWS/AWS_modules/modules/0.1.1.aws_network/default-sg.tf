resource "aws_security_group" "myec2common_01" {
  name        = "VPC_commonsg_01"
  description = "Allow TLS inbound traffic from AWS VPC CIDR"
  vpc_id      = aws_vpc.default.id
  #vpc_id = var.myec2_vpc_id
  revoke_rules_on_delete = true
  tags = merge(
    {
      Name            = "${var.project}-commonsg_01-cloud",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
  ingress {
    description = "ALL ingress from VPC CIDR "
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = var.cloud_cidr_block #AWS VPC CIDR
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "myec2common_02" {
  name        = "On-Prem_commonsg_02"
  description = "Allow TLS inbound traffic from On-PREM CIDR"
  vpc_id      = aws_vpc.default.id
  #vpc_id = var.myec2_vpc_id
  revoke_rules_on_delete = true
  tags = merge(
    {
      Name            = "${var.project}-commonsg_02-on-prem",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
  ingress {
    description = "ALL ingress from On-prem CIDR "
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = var.on_prem_cidr_block #vpc CIDR
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

