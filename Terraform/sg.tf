module "db_security_group" {
  source      = "terraform-aws-modules/security-group/aws"
  name        = module.naming.resources.sg.name
  description = "Security Group For The Private RDS"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "Allow Lambda to Connect to RDS Proxy and Proxy to Connect to RDS"
      cidr_blocks = "0.0.0.0/0"
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
