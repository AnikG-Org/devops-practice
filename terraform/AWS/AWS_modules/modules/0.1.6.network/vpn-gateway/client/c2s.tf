resource "aws_cloudwatch_log_group" "client_vpn" {
  name = "${var.name}-${var.project}-Client-VPN-log"

  tags = merge(
    var.tags,
    {
      "Name" = "${var.name}-${var.project}-ClientVpnConnection"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
  )
}

resource "aws_cloudwatch_log_stream" "client_vpn" {
  log_group_name = aws_cloudwatch_log_group.client_vpn.name
  name           = "${var.name}-${var.project}-Client-VPN-ls"
}

resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  client_cidr_block      = var.client_vpn_cidr_block
  description            = var.description
  server_certificate_arn = var.server_certificate_arn
  split_tunnel           = var.split_tunnel
  transport_protocol     = var.transport_protocol
  tags = merge(
    {
      "Name" = "${var.name}-${var.project}-ClientVpnEndPoint"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
  )
  dynamic "authentication_options" {
    for_each = var.type == "certificate-authentication" ? [var.type] : []
    content {
      type                       = "certificate-authentication"
      root_certificate_chain_arn = var.root_certificate_chain_arn
    }
  } 
  dynamic "authentication_options" {
    for_each = var.type == "directory-service-authentication" ? [var.type] : []
    content {
      type                  = "directory-service-authentication"
      active_directory_id   = var.active_directory_id
    }    
  }
  dynamic "authentication_options" {
    for_each = var.type == "federated-authentication" ? [var.type] : []
    content {
      type                           = "federated-authentication"
      saml_provider_arn              = var.saml_provider_arn
      #self_service_saml_provider_arn = var.self_service_saml_provider_arn
    }    
  }
  connection_log_options {
    cloudwatch_log_group  = aws_cloudwatch_log_group.client_vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.client_vpn.name
    enabled               = true
  }
}



resource "aws_ec2_client_vpn_network_association" "private" {
  count = length(var.private_subnets)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  subnet_id              = element(var.private_subnets, count.index)
  security_groups        = [aws_security_group.client_vpn_security_group.id]
}

resource "aws_ec2_client_vpn_network_association" "public" {
  count = length(var.public_subnets)

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  subnet_id              = element(var.public_subnets, count.index)
  security_groups        = [aws_security_group.client_vpn_security_group.id]
}

resource "aws_security_group" "client_vpn_security_group" {
  description = "Client VPN Security Group"
  name_prefix = "${var.name}-${var.project}-ClientVpnSecurityGroup"
  vpc_id      = var.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }

  tags = merge(
    {
      "Name" = "${var.name}-${var.project}-ClientVpnSecurityGroup"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ec2_client_vpn_authorization_rule" "all_authorization_rule" {

  for_each = var.aws_ec2_client_vpn_authorization_rule

  client_vpn_endpoint_id      = aws_ec2_client_vpn_endpoint.client_vpn.id
  target_network_cidr         = each.value["target_network_cidr"]
  authorize_all_groups        = each.value["authorize_all_groups"]
  access_group_id             = each.value["access_group_id"]
  description                 = each.value["description"]
}

resource "aws_ec2_client_vpn_route" "route" {
  for_each = var.aws_ec2_client_vpn_route

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn.id
  destination_cidr_block = each.value["destination_cidr_block"]
  description            = each.value["description"]
  target_vpc_subnet_id   = each.value["target_vpc_subnet_id"]
}
