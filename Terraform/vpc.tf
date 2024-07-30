module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.vpc.vpc_name
  cidr = local.vpc.vpc_cidr

  azs             = local.vpc.azs
  private_subnets = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 4, k)]
  #   public_subnets  = [for k, v in local.vpc.azs : cidrsubnet(local.vpc.vpc_cidr, 16, k + 4)]
  public_subnets = [cidrsubnet(local.vpc.vpc_cidr, 4, local.number_of_azs)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  #   enable_dns_support   = true

  tags = {
    Environment = local.environment
  }
}
