vpc_cidr            = "10.0.16.0/24"
project             = "lamablog"
project_short       = "lb"
naming_prefix       = "app"
environment         = "development"
number_of_azs       = 2
engine              = "mysql"
engine_version      = "8.0.35"
db_instance_class   = "db.t3.micro"
rds_storage         = 20
s3force_destroy     = true
s3versioning        = false
multi_az            = false
deletion_protection = false
price_class         = "PriceClass_All"
default_root_object = "index.html"
