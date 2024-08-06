module "rds_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = module.naming.resources.sg.name
  description = "Security Group For The Private RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Allow Lambda to Connect to RDS Proxy and Proxy to Connect to RDS"
      source_security_group_id = module.rds_proxy_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = " "
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "rds_proxy_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "proxy-${module.naming.resources.sg.name}"
  description = "Security Group For The Private RDS Proxy"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Allow Lambda to Connect to RDS Proxy and Proxy to Connect to RDS"
      source_security_group_id = module.lambda_sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Outbound All"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

module "lambda_sg" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = "lambda-${module.naming.resources.sg.name}"
  description = "Security Group For The Lambda"
  vpc_id      = module.vpc.vpc_id

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Outbound All"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
