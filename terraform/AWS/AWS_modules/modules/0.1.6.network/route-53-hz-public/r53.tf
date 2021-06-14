resource "aws_route53_zone" "public_zone" {
  comment = "${var.name}- Hosted zone for ENV ${var.environment}.${var.project}"
  name    = lower(var.name)
 tags = merge(
   {
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
   },
   var.tags
   )

}

######################## Variable

variable "name" {
  description = "TLD for Internal Hosted Zone. ( example.com )"
  type        = string
}
variable "vpc_id" {
  description = "Select Virtual Private Cloud ID. ( vpc-* )"
  type        = string
}
