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

output "rds_proxy_identifier" {
  value = module.rds_proxy.proxy_endpoint
}

output "s3bucket" {
  value = module.s3_bucket.s3_bucket_id
}

output "vpc_sg" {
  value = module.vpc.default_security_group_id
}
