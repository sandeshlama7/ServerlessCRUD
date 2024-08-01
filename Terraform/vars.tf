variable "region" {
  description = "Region where resources will be created"
  type        = string
  default     = "us-east-1"
}

########################
# VPC variables
########################

variable "vpc_cidr" {
  description = "CIDR of the VPC"
  type        = string
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "lama-blog"
}

variable "project_short" {
  description = "Short form of the project"
  type        = string
  default     = "lb"
}

variable "environment" {
  description = "Environment of the project"
  type        = string
}

variable "number_of_azs" {
  description = "Number of AZs in the region"
  type        = number
}

########################
# S3 variables
########################
# variable "force_destroy" {
#   description = "Whether to force destroy the bucket"
#   type        = bool
# }


##################
# RDS variables
#################
variable "engine" {
  description = "THe SQL engine for the RDS"
  type        = string
}
variable "engine_version" {
  description = "The SQL engine version"
  type        = string
}
variable "db_instance_class" {
  description = "The instance type of the RDS DB Instance"
  type        = string
}
variable "rds_storage" {
  description = "The amount of Storage for RDS in GiB"
  type        = number
}

# variable "proxy_name" {
#   description = "The name for the RDS Proxy"
#   type = string
# }

# variable "proxy_role" {
#   description = "The name of the IAM Role for the RDS Proxy"
#   type = string
# }
