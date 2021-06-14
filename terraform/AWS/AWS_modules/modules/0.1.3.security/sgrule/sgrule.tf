##########
resource "aws_security_group_rule" "sg_rule" {
  count = var.create_sg_rule ? length(var.ingress_rules) : 0

  security_group_id = var.sgrule_security_group_id
  type              = "ingress"

  cidr_blocks              = var.ingress_cidr_blocks
  ipv6_cidr_blocks         = var.sgrule_ipv6_cidr_blocks
  prefix_list_ids          = var.sgrule_prefix_list_ids
  description              = var.rules[var.ingress_rules[count.index]][3]

  from_port = var.rules[var.ingress_rules[count.index]][0]
  to_port   = var.rules[var.ingress_rules[count.index]][1]
  protocol  = var.rules[var.ingress_rules[count.index]][2]  #ingress_rules = ["https-443-tcp"]
}
resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count = var.create_sg_rule ? length(var.ingress_with_cidr_blocks) : 0
  security_group_id = var.sgrule_security_group_id
  type              = "ingress"

  cidr_blocks = split(
    ",",
    lookup(
      var.ingress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.ingress_cidr_blocks),
    ),
  )
  prefix_list_ids = var.sgrule_prefix_list_ids
  description = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}