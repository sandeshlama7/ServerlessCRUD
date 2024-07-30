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
