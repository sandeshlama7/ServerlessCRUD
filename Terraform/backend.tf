terraform {
  backend "s3" {
    bucket = "8586-terraform-state"
    key    = "development/terraform.tfstate"
    region = "us-east-1"
  }
}
