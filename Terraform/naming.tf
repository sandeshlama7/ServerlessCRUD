module "naming" {
  source         = "./modules/naming"
  app_name_short = "lb"
  app_name       = "lama-blog"
  environment    = local.environment
}
