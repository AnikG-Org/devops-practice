
################################################################################
# Customer Gateways
################################################################################
resource "aws_customer_gateway" "this" {
  for_each = var.create_cgw ? var.customer_gateways : {}

  bgp_asn    = each.value["bgp_asn"]
  ip_address = each.value["ip_address"]
  type       = "ipsec.1"

  tags = merge(
    {
      Name = format("CustomerGateway-%s-%s", var.project, each.key)
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags,
    var.customer_gateway_tags,
  )
}
