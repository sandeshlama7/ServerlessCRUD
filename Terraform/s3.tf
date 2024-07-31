module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket              = local.frontend_bucket.name
  attach_policy       = true
  block_public_policy = false

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  website = {
    index_document : "index.html"
    error_document : "index.html"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        # Resource  = "${module.s3_bucket.bucket_arn}/*"
        Resource = "arn:aws:s3:::${local.frontend_bucket.name}/*"
      }
    ]
  })
}
