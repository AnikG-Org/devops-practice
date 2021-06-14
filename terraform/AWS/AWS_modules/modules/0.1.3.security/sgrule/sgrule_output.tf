output "sg_rule" {
  value = aws_security_group_rule.sg_rule[*]
}

output "ingress_with_cidr_blocks" {
  value = aws_security_group_rule.ingress_with_cidr_blocks[*]
}