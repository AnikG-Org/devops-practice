
################################################################################
locals {
  enable_vpc_s3_endpoint = var.enable_vpc_s3_endpoint
  private_rt_count       = var.enable_nat_gateway ? local.nat_count : 1
  ngw_count              = var.enable_nat_gateway ? local.nat_count : 0
  nat_count              = var.single_nat_gateway ? 1 : length(aws_subnet.public[*].availability_zone) #length(var.public_subnet_cidr_blocks)
  single_nat_gateway = {
    true = {
      HA = "Disabled"
    }
    false = {
      HA = "Enabled"
    }
  }

}
################################################################################
#VPC---------------------------------------

resource "aws_vpc" "default" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = var.instance_tenancy
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = var.assign_generated_ipv6_cidr_block

  tags = merge(
    {
      Name            = "${var.project}-${var.name}-VPC-NetWork",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
################################################################################
#Route-Table---------------------------------------

resource "aws_route_table" "private" {
  count  = local.private_rt_count
  vpc_id = aws_vpc.default.id
  tags = merge(
    {
      Name            = "${var.project}-Private_RT_NetWork-${count.index + 001}",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
      pvt_rt_seq      = count.index + 001
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags = merge(
    {
      Name            = "${var.project}-Public_RT_NetWork",
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}

################################################################################
# Default route table
resource "aws_default_route_table" "default" {
  count = var.manage_default_route_table ? 1 : 0

  default_route_table_id = aws_vpc.default.default_route_table_id
  propagating_vgws       = var.default_route_table_propagating_vgws

  dynamic "route" {
    for_each = var.default_route_table_routes
    content {
      # One of the following destinations must be provided
      cidr_block      = route.value.cidr_block
      ipv6_cidr_block = lookup(route.value, "ipv6_cidr_block", null)

      # One of the following targets must be provided
      egress_only_gateway_id    = lookup(route.value, "egress_only_gateway_id", null)
      gateway_id                = lookup(route.value, "gateway_id", null)
      instance_id               = lookup(route.value, "instance_id", null)
      nat_gateway_id            = lookup(route.value, "nat_gateway_id", null)
      network_interface_id      = lookup(route.value, "network_interface_id", null)
      transit_gateway_id        = lookup(route.value, "transit_gateway_id", null)
      vpc_endpoint_id           = lookup(route.value, "vpc_endpoint_id", null)
      vpc_peering_connection_id = lookup(route.value, "vpc_peering_connection_id", null)
    }
  }

  tags = merge(
    {
      Name              = "${var.project}-default-route-table"
      Environment       = var.environment
      Created_Via       = "Terraform IAAC"
      Project           = var.project
      SCM               = var.git_repo
      ServiceProvider   = var.ServiceProvider
      DefaultRouteTable = true
    },
    var.tags,
    var.default_route_table_tags,
  )
  depends_on = [aws_vpc.default]
}

#Route rules--------------------------------------------------

resource "aws_route" "private_nat_gateway" {
  count = local.ngw_count

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.default.*.id, count.index)
  route_table_id         = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}
resource "aws_route" "public_internet_gateway_ipv6" {
  route_table_id              = aws_route_table.public.id
  destination_ipv6_cidr_block = "::/0"
  gateway_id                  = aws_internet_gateway.default.id
}

#route_table_association---------------------------------------
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id = aws_subnet.private[count.index].id #element(aws_subnet.private.*.id, count.index)
  #route_table_id = aws_route_table.private.id
  route_table_id = element(aws_route_table.private.*.id, count.index)
  # route_table_id = element(
  #   aws_route_table.private.*.id,
  #   var.single_nat_gateway ? 0 : count.index,
  # )
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
################################################################################
#Subnets---------------------------------------

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name            = "${var.project}-Private_SubNet_NetWork-${count.index + 1}"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.default.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    {
      Name            = "${var.project}-Public_SubNet_NetWork-${count.index + 1}"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
################################################################################
#---------------------------IGW---------------------------------------------
resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name            = "${var.project}-IGW"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}


# NAT resources---------------------------------------

resource "aws_eip" "nat" {
  count = local.ngw_count
  vpc   = true
  tags = merge(
    {
      Name             = "${var.project}-NGW-EIP-${count.index + 001}",
      Environment      = var.environment
      Created_Via      = "Terraform IAAC"
      Project          = var.project
      SCM              = var.git_repo
      ServiceProvider  = var.ServiceProvider
      ngw_eip_sequence = count.index + 001
    },
    var.tags
  )
}

resource "aws_nat_gateway" "default" {
  count = local.ngw_count

  #allocation_id = aws_eip.nat.id
  #subnet_id     = aws_subnet.public[0].id
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)

  tags = merge(
    local.single_nat_gateway[var.single_nat_gateway],
    {
      Name            = "${var.project}-NGW-${count.index + 001}"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
      ngw_sequence    = count.index + 001
    },
    var.tags
  )
  depends_on = [aws_internet_gateway.default]
}
################################################################################
# DHCP Options Set
resource "aws_vpc_dhcp_options" "this" {
  count                = var.enable_custom_dhcp_options ? 1 : 0
  domain_name          = var.dhcp_options_domain_name
  domain_name_servers  = var.dhcp_options_domain_name_servers
  ntp_servers          = var.dhcp_options_ntp_servers
  netbios_name_servers = var.dhcp_options_netbios_name_servers
  netbios_node_type    = var.dhcp_options_netbios_node_type

  tags = merge(
    {
      Name                    = format("custom-dhcp-optionsets-%s", var.project)
      customDHCPOptions_Inuse = format("${var.enable_custom_dhcp_options}-%s", aws_vpc.default.id)
      Environment             = var.environment
      Created_Via             = "Terraform IAAC"
      Project                 = var.project
      SCM                     = var.git_repo
      ServiceProvider         = var.ServiceProvider
    },
    var.dhcp_options_tags,
  )
  depends_on = [aws_vpc.default]
}
resource "aws_vpc_dhcp_options_association" "this" {
  count           = var.enable_custom_dhcp_options ? 1 : 0
  vpc_id          = aws_vpc.default.id
  dhcp_options_id = aws_vpc_dhcp_options.this[0].id

  depends_on = [aws_vpc_dhcp_options.this]
}
#########

#aws_vpc_S3_endpoint---------------------------------------

resource "aws_vpc_endpoint" "s3" {
  count = local.enable_vpc_s3_endpoint ? 1 : 0

  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.provider_region}.s3"
  route_table_ids = flatten([
    aws_route_table.public.id,
    #aws_route_table.private.id
    aws_route_table.private.*.id
  ])

  tags = merge(
    {
      Name            = "${var.project}-endpointS3"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
  depends_on = [aws_vpc.default]
}
#-------------------------------------