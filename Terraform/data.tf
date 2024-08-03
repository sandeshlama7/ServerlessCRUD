data "aws_availability_zones" "available" {
  state = "available"
}
data "aws_route53_zone" "r53zone" {
  name         = "sandbox.adex.ltd"
  private_zone = false
}
