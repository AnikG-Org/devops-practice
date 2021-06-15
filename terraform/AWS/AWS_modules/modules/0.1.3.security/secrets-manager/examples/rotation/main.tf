module "secrets-manager-4" {

  source = "../../"

  rotate_secrets = [
    {
      name                    = "secret-rotate-1"
      description             = "This is a secret to be rotated by a lambda"
      secret_string           = "This is an example"
      rotation_lambda_arn     = "arn:aws:lambda:us-east-1:123455678910:function:lambda-rotate-secret"
      recovery_window_in_days = 15
    },
    {
      name                    = "secret-rotate-2"
      description             = "This is another secret to be rotated by a lambda"
      secret_string           = "This is another example"
      rotation_lambda_arn     = "arn:aws:lambda:us-east-1:123455678910:function:lambda-rotate-secret"
      recovery_window_in_days = 7
    },
  ]

  tags = {
    Owner       = "DevOps team"
    Environment = "dev"
    Terraform   = true
  }

}

# Lambda to rotate secrets
# AWS temaplates available here https://github.com/aws-samples/aws-secrets-manager-rotation-lambdas
module "rotate_secret_lambda" {
  source = "../../modules/0.1.5.devops/lambda"

  function_name = "secrets_manager_rotation"
  description   = "My awesome lambda function Created via Terraform IAAC"
  handler       = "index.lambda_handler"
  runtime       = "python3.6"
  create_role   = true

  source_path = "${path.module}/secrets_manager_rotation.zip"

  environment = {
    variables = {
      SECRETS_MANAGER_ENDPOINT = "https://secretsmanager.us-east-1.amazonaws.com"
    }
  }
}


resource "aws_lambda_permission" "allow_secret_manager_call_Lambda" {
  function_name = module.rotate_secret_lambda.function_name
  statement_id  = "AllowExecutionSecretManager"
  action        = "lambda:InvokeFunction"
  principal     = "secretsmanager.amazonaws.com"
}

