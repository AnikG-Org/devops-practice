
locals {
  aws_customer_gateway_id  = [for k, v in aws_customer_gateway.this : v.id]
  # vpn_gateway = element(
  #   compact(
  #     concat(aws_vpn_gateway.this.*.id, [var.existing_vpn_gateway]),
  #   ),
  #   0,
  # )
  # customer_gateway = element(
  #   compact(
  #     concat(
  #       local.aws_customer_gateway_id,        
  #       [var.existing_customer_gateway],
  #     ),
  #   ),
  #   0,
  # )
}
################################################################################
################################################################################
# VPN Gateway
################################################################################

resource "aws_vpn_gateway" "this" {
  count = var.enable_vpn_gateway ? 1 : 0

  vpc_id            = var.vpc_id
  amazon_side_asn   = var.amazon_side_asn
  availability_zone = var.availability_zone

  tags = merge(
    {
      "Name" = "${var.customvgwname}-VPNGateway-${var.project}"
      "transitvpc:spoke" = var.spoke_vpc ? "True" : "False"
    },
    var.tags,
    var.vpn_gateway_tags,
  )
}
resource "aws_vpn_gateway_attachment" "this" {
  count          = var.vpn_gateway_attachment ? 1 : 0

  vpc_id         = var.vpc_id
  vpn_gateway_id = element(compact(concat(aws_vpn_gateway.this.*.id, [var.existing_vpn_gateway]),),0,)
}

###########################################################################################
################################# aws vpn connection ######################################
resource "aws_vpn_connection" "vpn" {
  count = var.create_vpn_connection ? 1 : 0

  customer_gateway_id   = element(compact(concat(local.aws_customer_gateway_id,[var.existing_customer_gateway],),),0,)
  static_routes_only    = var.disable_bgp
  tunnel1_inside_cidr   = length(var.bgp_inside_cidrs) >= 2 ? element(var.bgp_inside_cidrs, 0) : null
  tunnel1_preshared_key = length(var.preshared_keys) > 0 ? element(var.preshared_keys, 0) : null
  tunnel2_inside_cidr   = length(var.bgp_inside_cidrs) >= 2 ? element(var.bgp_inside_cidrs, 1) : null
  tunnel2_preshared_key = length(var.preshared_keys) > 0 ? element(var.preshared_keys, 1) : null
  type                  = "ipsec.1"
  vpn_gateway_id        = element(compact(concat(aws_vpn_gateway.this.*.id, [var.existing_vpn_gateway]),),0,)
  transit_gateway_id    = var.transit_gateway_id

  # local_ipv4_network_cidr  = var.local_ipv4_network_cidr
  # remote_ipv4_network_cidr = var.remote_ipv4_network_cidr
  # local_ipv6_network_cidr  = var.local_ipv6_network_cidr
  # remote_ipv6_network_cidr = var.remote_ipv6_network_cidr

  tags = merge(
    var.tags,
    var.vpn_gateway_tags,
    {
      "Name" = "${var.customvgwname}-VpnConnection-${var.project}"
    },
  )
}
resource "aws_vpn_connection_route" "static_routes" {
  count = var.create_vpn_connection && var.disable_bgp == true ? length(var.static_routes) : 0 #***

  destination_cidr_block = element(var.static_routes, count.index)
  vpn_connection_id      = element(aws_vpn_connection.vpn[*].id, count.index)
}
############################### VGW RT association #################################################
resource "aws_vpn_gateway_route_propagation" "route_propagation" {
  count = var.enable_route_propagation ? length(var.route_tables) : 0

  route_table_id = element(var.route_tables, count.index)   #tfvar use EXAMPLE >> route_tables  = concat(module.aws_network_1.public_aws_route_table, module.aws_network_1.private_aws_route_table)
  vpn_gateway_id = element(compact(concat(aws_vpn_gateway.this.*.id, [var.existing_vpn_gateway]),),0,)
}
################################################################################
