
#VPC---------------------------------------

resource "aws_vpc" "default" {
  cidr_block                       = var.cidr_block
  instance_tenancy                 = "default"
  enable_dns_support               = true
  enable_dns_hostnames             = true
  assign_generated_ipv6_cidr_block = false

  tags = merge(
    {
      Name = "${var.project}-${var.name}-VPC-NetWork",
    },
    var.tags
  )
}

#Route-Table---------------------------------------

resource "aws_route_table" "private" {
  #count = length(var.private_subnet_cidr_blocks)
  vpc_id = aws_vpc.default.id
  tags = merge(
    {
      Name = "${var.project}-Private_RT_NetWork",
      #timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    },
    var.tags
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id
  tags = merge(
    {
      Name = "${var.project}-Public_RT_NetWork",
      #timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    },
    var.tags
  )
}

#Routes----------------------------------------

resource "aws_route" "private" {
  #count = length(var.private_subnet_cidr_blocks)
  #route_table_id         = aws_route_table.private[count.index].id
  #nat_gateway_id         = aws_nat_gateway.default[count.index].id       #enable oif HA NGW required
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.default.id
  #vpc_peering_connection_id = "pcx-xxxx"
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
  #vpc_peering_connection_id = "pcx-xxxx"
}

#route_table_association---------------------------------------
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr_blocks)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
  #route_table_id = aws_route_table.private[count.index].id
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr_blocks)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#Subnets---------------------------------------

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.default.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    {
      Name = "${var.project}-Private_SubNet_NetWork-${count.index + 1}"
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
      Name = "${var.project}-Public_SubNet_NetWork-${count.index + 1}",
      #timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    },
    var.tags
  )
}

#aws_vpc_endpoint---------------------------------------
/*
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.default.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = flatten([
    aws_route_table.public.id,
    aws_route_table.private.id
    #aws_route_table.private.*.id
  ])

  tags = merge(
    {
      Name        = "${var.project}-endpointS3"
    },
    var.tags
  )
}
*/
# IGW ---------------------------------------

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = merge(
    {
      Name = "${var.project}-IGW",
      #timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    },
    var.tags
  )
}


# NAT resources---------------------------------------

resource "aws_eip" "nat" {
  # = length(var.public_subnet_cidr_blocks)
  vpc = true
  tags = {
    Name      = "${var.project}-NGW-EIP",
    timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
  }
}

resource "aws_nat_gateway" "default" {
  depends_on = [aws_internet_gateway.default]
  #count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
  #subnet_id     = aws_subnet.public[count.index].id
  #allocation_id = aws_eip.nat[count.index].id
  tags = merge(
    {
      Name = "${var.project}-NGW",
      #timestamp = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
    },
    var.tags
  )
}

#-------------------------------------