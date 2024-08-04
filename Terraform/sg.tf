resource "aws_security_group" "rds_sg" {
  name        = module.naming.resources.sg.name
  description = "Security Group For The Private RDS"
  vpc_id      = module.vpc.default_vpc_id

  ingress {
    description     = "Allow Lambda Access to RDS"
    security_groups = [module.vpc.default_security_group_id]
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
  }
}
