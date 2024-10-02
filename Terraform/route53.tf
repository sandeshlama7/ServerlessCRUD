module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = data.aws_route53_zone.r53zone.name

  records = [
    {
      name = "${local.project}.${local.environment}"
      type = "A"
      alias = {
        name = module.cdn.cloudfront_distribution_domain_name
        # zone_id = data.aws_route53_zone.r53zone.zone_id
        zone_id = module.cdn.cloudfront_distribution_hosted_zone_id
      }
    }
  ]
}
