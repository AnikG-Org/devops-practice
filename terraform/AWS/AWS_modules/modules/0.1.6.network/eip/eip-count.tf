resource "aws_eip" "eip" {
  count = var.eip_count
  vpc   = true

  tags = merge(
    var.additional_tags,
    {
      Name            = "${var.project}-${var.eiptagname}-${count.index + 001}"
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
      sequence        = count.index + 001
    },
    var.tags
  )
}
##########################################################
variable "eiptagname" { default = "eip" }
variable "eip_count" {
  type    = number
  default = 1
}
variable "additional_tags" {
  type    = map(string)
  default = {}
}
##########################################################
output "output_aws_eip" {
  value = aws_eip.eip[*]
}
output "output_aws_eip_id" {
  value = aws_eip.eip[*].id
}