resource "aws_iam_instance_profile" "myec2role_profile" {
  name = "ec2_admin_role-${local.random_string}"
  role = aws_iam_role.myec2role.name

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

#---------IAM-------

resource "aws_iam_role" "myec2role" {
  name = "ec2-admin-role-${local.random_string}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
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

resource "aws_iam_policy" "myec2_admin_policy" {
  name        = "ec2_admin_policy-${local.random_string}"
  description = "ec2_admin_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
      tags = merge(
      {
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider       
      },
    ) 
}

resource "aws_iam_policy_attachment" "attach" {
  name       = "policy-attachment"
  #users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.myec2role.name]
  #groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.myec2_admin_policy.arn
}