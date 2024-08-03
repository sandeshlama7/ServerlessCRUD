module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

    aliases = [local.domain_name]

  comment             = "LamaBlog CloudFront"
  enabled             = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  default_root_object = "index.html"

create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "CloudFront access to S3"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }


  origin = {
    s3static = {
      domain_name = module.s3_bucket.s3_bucket_bucket_domain_name
        origin_access_control = "s3_oac"
  }
  }

  default_cache_behavior = {
    target_origin_id       = "s3static"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
    viewer_protocol_policy = "redirect-to-https"

  }

  viewer_certificate = {
    acm_certificate_arn = module.acm.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }
}
