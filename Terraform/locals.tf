locals {
  region = var.region
  prefix = "${var.project}-${var.environment}"

  vpc = {
    vpc_name = "${local.prefix}-vpc"
    vpc_cidr = var.vpc_cidr
    azs      = slice(data.aws_availability_zones.available.names, 0, var.number_of_azs)
  }

  project       = var.project
  environment   = var.environment
  number_of_azs = var.number_of_azs
}
