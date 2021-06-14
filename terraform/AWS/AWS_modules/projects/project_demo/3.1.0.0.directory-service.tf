module "directory_service" {
  source = "../../modules/0.1.6.network/directory-service"

  enable_directory_service = false

  name       = "corp.testqueues.com"
  password   = module.random_gen_1.random_passwd
  type       = "MicrosoftAD"
  edition    = "Standard"
  subnet_ids = [module.aws_network_1.private_subnet_ids[0], module.aws_network_1.private_subnet_ids[1]]

  tags = {
    Name = "testqueues.com-directory-service"
  }
}
############################  