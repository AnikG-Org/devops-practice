/* #enable when required
############################# # RDS Aurora Module - MySQL serverless ###################

module "aurora_mysql" {
  source          = "../../modules/0.1.8.storage/rds-aurora-serverless-db"
  

  name              = "mysql-aurora"
  engine            = "aurora-mysql"
  engine_mode       = "serverless"
  storage_encrypted = true
  create_random_password = false
  password          = module.random_gen_1.random_passwd  # if create_random_password = false then use password for master password

  vpc_id                = module.aws_network_1.vpc_id
  subnets               = [module.aws_network_1.private_subnet_ids[0],module.aws_network_1.private_subnet_ids[1]]
  create_security_group = true
  allowed_cidr_blocks   = ["0.0.0.0/0"]

  replica_scale_enabled = false
  replica_count         = 0

  monitoring_interval = 60

  apply_immediately   = false  # "Determines whether or not any DB modifications are applied immediately, or during the maintenance window"
  skip_final_snapshot = true

  db_parameter_group_name         = module.aurora_mysql.aws_db_parameter_group_id[0]
  db_cluster_parameter_group_name = module.aurora_mysql.aws_rds_cluster_parameter_group_id[0]
  # enabled_cloudwatch_logs_exports = # NOT SUPPORTED

  scaling_configuration = {
    auto_pause               = true
    min_capacity             = 2
    max_capacity             = 16
    seconds_until_auto_pause = 300
    timeout_action           = "ForceApplyCapacityChange"
  }
  #aws_db_parameter_group
  aws_db_parameter_group_family      = "aurora-mysql5.7"  
}

*/