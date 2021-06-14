#---------IAM-------

resource "aws_iam_role" "servicerole" {
  name = var.custom_iam_name

  assume_role_policy = local.assume_role_policy

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

resource "aws_iam_policy" "custom_profile" {
  name        = var.custom_iam_name
  description = "custom_policy"

  policy = var.policy
}

########## Association
resource "aws_iam_instance_profile" "custom_profile" {
  name = var.custom_iam_name
  role = aws_iam_role.servicerole.name

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
resource "aws_iam_policy_attachment" "attach" {
  name       = "policy-attachment"
  #users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.servicerole.name]
  #groups     = [aws_iam_group.group.name]
  policy_arn = aws_iam_policy.custom_profile.arn
}
############################################ VARIABLE

variable "custom_iam_name" { default = "custom_iam_role" }
variable "policy" {
  type = any
  default = {}
}

##########  OUTPUT #########################
output "custom_iam" {
  value = zipmap(["custom_iam_role_arn", "iam_custom_service_profile_arn", "iam_custom_service_profile_name"], [aws_iam_role.servicerole.arn, aws_iam_policy.custom_profile.arn, aws_iam_instance_profile.custom_profile.name])
}

########################################################### format example for assume_role_policy & aws_iam_policy #################
locals {

  assume_role_policy = <<-EOF
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

}


############################################