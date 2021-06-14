resource "aws_iam_policy" "policy" {
  name        = var.name
  path        = var.path
  description = var.description

  policy = var.policy

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

