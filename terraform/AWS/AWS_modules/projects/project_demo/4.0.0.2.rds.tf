/* #enable when required

module "rds_mysql" {
  source          = "../../modules/0.1.8.storage/rds"
  

  identifier = "rdsdb"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5

  name     = "rdsdb"
  username = "admin"
  password = module.random_gen_1.random_passwd
  port     = "3306"

  iam_database_authentication_enabled = false
  skip_final_snapshot = true
  vpc_security_group_ids = [module.count_security_groups_5.output_dynamicsg_v2[0]]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval = "30"
  monitoring_role_name = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
  }

  # DB subnet group
  subnet_ids = [module.aws_network_1.private_subnet_ids[0],module.aws_network_1.private_subnet_ids[1]]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

*/