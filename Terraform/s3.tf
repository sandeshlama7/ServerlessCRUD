module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket              = local.frontend_bucket.name
  attach_policy       = true
  block_public_policy = false

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = local.s3versioning
  }

  force_destroy = local.s3force_destroy

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service : "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::${local.frontend_bucket.name}/*"
        # "Condition" = {
        #   "StringEquals": {
        #     "AWS:SourceArn": module.cdn.arn
        #   }
        # }
      }
    ]
  })
}
