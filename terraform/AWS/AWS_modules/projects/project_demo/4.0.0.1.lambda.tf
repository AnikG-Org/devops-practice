/*  #enable when requirded

provider "aws" {
  region = var.provider_region
  alias  = "lambda"
  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = false
  skip_credentials_validation = true
  skip_requesting_account_id  = true
 
}



module "lambda_function_in_vpc" {
  source          = "../../modules/0.1.5.devops/lambda"
  providers       = { aws = aws.lambda }
  
  function_name = "lambda-in-vpc-StartStopScript"
  description   = "My awesome lambda function Created via Terraform IAAC"
  handler       = "index.lambda_handler"
  runtime       = "python3.6"
  create_role   = true
  #lambda_role   = "arn:aws:iam::388891221585:role/lambda_role"  #use lambda_role when create_role   = false

  source_path = "${path.module}/lambda/StartStopScript.py"

  vpc_subnet_ids         = module.aws_network_1.private_subnet_ids[*]
  vpc_security_group_ids = [module.count_security_groups_4.output_dynamicsg_v2[0]]
  attach_network_policy  = true

 
}

*/