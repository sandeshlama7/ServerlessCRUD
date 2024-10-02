module "rds" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.rds_identifier

  engine                = local.engine
  engine_version        = local.engine_version
  instance_class        = local.db_instance_class
  allocated_storage     = local.rds_storage
  max_allocated_storage = local.max_storage
  multi_az              = local.multi_az


  db_name  = local.rds_db
  username = local.rds_username
  port     = local.rds_port

  manage_master_user_password_rotation                   = local.password_rotation
  master_user_password_rotation_automatically_after_days = local.password_rotation_frequency

  vpc_security_group_ids = [module.vpc.default_security_group_id, module.rds_sg.security_group_id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # Enhanced Monitoring
  monitoring_interval    = "30"
  monitoring_role_name   = "${local.rds_identifier}-MonitoringRole"
  create_monitoring_role = true

  # DB subnet group
  create_db_subnet_group = true
  subnet_ids             = module.vpc.private_subnets

  # DB parameter group
  create_db_parameter_group = false
  # family = "mysql8.0"

  # DB option group
  create_db_option_group = false
  # major_engine_version = "8.0"

  skip_final_snapshot = true

  # Database Deletion Protection
  #   deletion_protection = local.deletion_protection

}
