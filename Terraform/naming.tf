module "naming" {
  source         = "./modules/naming"
  app_name       = local.project
  app_name_short = local.project_short
  environment    = local.environment
  project_prefix = local.naming_prefix
}
