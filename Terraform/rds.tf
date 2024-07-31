module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.rds_identifier

  engine            = local.engine
  engine_version    = local.engine_version
  instance_class    = local.db_instance_class
  allocated_storage = local.rds_storage
  # multi_az = true

  db_name  = "blogs"
  username = "admin"
  port     = "3306"

  vpc_security_group_ids = [module.vpc.default_security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "RDSMonitoringRole"
  create_monitoring_role = true

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  #   # DB parameter group
  family = "mysql8.0"

  #   # DB option group
  major_engine_version = "8.0"

  #   # Database Deletion Protection
  # #   deletion_protection = true

}
