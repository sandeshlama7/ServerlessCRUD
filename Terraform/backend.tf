terraform {
  backend "s3" {
    # bucket = <bucket_name>
    # key    = "${local.environment}/terraform.tfstate"
    # region = <aws_region>
  }
}
