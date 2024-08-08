output "vpc_id" {
  value = module.vpc.vpc_id
}
output "private_subnet_ids" {
  value = module.vpc.private_subnets
}
output "public_subnet_ids" {
  value = module.vpc.public_subnets
}
output "rds_identifier" {
  value = module.rds.db_instance_identifier
}
output "s3bucket" {
  value = module.s3_bucket.s3_bucket_id
}
output "vpc_sg" {
  value = module.vpc.default_security_group_id
}
output "rds_db_name" {
  value = local.rds_db
}
output "rds_username" {
  value = module.rds.db_instance_username
}
output "rds_proxy_endpoint" {
  value = module.rds_proxy.proxy_endpoint
}
output "lambdaSG" {
  value = module.lambda_sg.security_group_id
}
output "secretsARN" {
  value = module.rds.db_instance_master_user_secret_arn
}
output "domainAddress" {
  value = "https://${local.domain_name}"
}
