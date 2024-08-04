module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  # domain_name  = module.records.route53_record_name
  #   domain_name = module.cdn.cloudfront_distribution_domain_name
  domain_name = local.domain_name
  zone_id     = data.aws_route53_zone.r53zone.zone_id

  validation_method = "DNS"

  subject_alternative_names = [
    "*.lamablog.sandbox.adex.ltd",
  ]

  wait_for_validation = true

  tags = {
    Name = local.domain_name
  }
}
