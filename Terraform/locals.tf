locals {
  region        = var.region
  prefix        = "${var.project}-${var.environment}"
  naming_prefix = var.naming_prefix

  ###### VPC
  vpc = {
    name = module.naming.resources.vpc.name
    cidr = var.vpc_cidr
    azs  = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  }
  number_of_azs = var.number_of_azs

  ###### Tags
  project_short = var.project_short
  project       = var.project
  environment   = var.environment

  ###### RDS
  rds_identifier    = module.naming.resources.rds.name
  engine            = var.engine
  engine_version    = var.engine_version
  db_instance_class = var.db_instance_class
  rds_storage       = var.rds_storage
  max_storage       = var.max_storage
  multi_az          = var.multi_az
  rds_db            = var.rds_db
  rds_username      = var.rds_username
  rds_port          = var.rds_port

  proxy_name = "${local.rds_identifier}-proxy"
  proxy_role = "${local.proxy_name}-role"

  deletion_protection = var.deletion_protection

  #### S3
  frontend_bucket = {
    name = module.naming.resources.s3.name
  }
  s3force_destroy = var.s3force_destroy
  s3versioning    = var.s3versioning

  domain_name = "${local.project}.${local.environment}.sandbox.adex.ltd"
  # domain_name = "${local.project}.sandbox.adex.ltd"

  #### Cloudfront
  price_class         = var.price_class
  default_root_object = var.default_root_object

}
