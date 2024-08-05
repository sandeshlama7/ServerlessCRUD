module "rds_proxy" {
  source = "terraform-aws-modules/rds-proxy/aws"

  name                   = local.proxy_name
  iam_role_name          = local.proxy_role
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.vpc.default_security_group_id, module.db_security_group.security_group_id]

  auth = {
    "${local.rds_db}" = {
      description = "RDS MySQL admin password"
      secret_arn  = module.rds.db_instance_master_user_secret_arn
    }
  }

  # Target MySQL Instance
  engine_family = "MYSQL"
  debug_logging = true

  # Target RDS instance
  target_db_instance     = true
  db_instance_identifier = module.rds.db_instance_identifier

}
