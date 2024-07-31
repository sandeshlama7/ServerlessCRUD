locals {
  region = var.region
  prefix = "${var.project}-${var.environment}"

  ###### VPC
  vpc = {
    # name = "${local.prefix}-vpc"
    name = module.naming.resources.vpc.name
    cidr = var.vpc_cidr
    azs  = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  }
  number_of_azs = var.number_of_azs

  ###### Tags
  project     = var.project
  environment = var.environment

  ###### RDS
  rds_identifier    = "${local.prefix}-db"
  engine            = var.engine
  engine_version    = var.engine_version
  db_instance_class = var.db_instance_class
  rds_storage       = var.rds_storage
  proxy_name        = "${local.rds_identifier}-proxy"
  proxy_role        = "${local.proxy_name}-role"

  #### S3
  frontend_bucket = {
    name = "${local.prefix}-frontend-bucket"
  }
}
