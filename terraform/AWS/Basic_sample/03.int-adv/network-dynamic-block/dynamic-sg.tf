resource "aws_security_group" "dynamicsg_1" {
  name        = "dynamicsg-01"
  description = "Ingress for Vault"
  vpc_id      = aws_vpc.default.id
  count       = length(var.private_subnet_cidr_blocks)

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = ports

    content {
      from_port   = ports.value
      to_port     = ports.value
      protocol    = "tcp"
      cidr_blocks = [aws_subnet.private[count.index].id]
    }
  }
}

resource "aws_security_group" "dynamicsg_2" {
  name        = "dynamicsg-02"
  description = "Ingress from internet for webserver"
  vpc_id      = aws_vpc.default.id

  dynamic "ingress" {
    for_each = var.sg_ports_1
    iterator = ports

    content {
      from_port   = ports.value
      to_port     = ports.value
      protocol    = "tcp"
      cidr_blocks = [var.myec2sgcidr_1]
    }
  }
  dynamic "egress" {
    for_each = var.sg_ports_1
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "all"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}