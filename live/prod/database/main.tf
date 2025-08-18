provider "aws" {
  region = "us-east-2"
}

locals {
  project_name = "myapp"
  environment  = "prod"
}

module "rds" {
  source = "../../../modules/database/rds"
  
  project_name        = local.project_name
  environment         = local.environment
  db_username         = var.db_username
  db_password         = var.db_password
  
  allocated_storage     = 20
  instance_class       = "db.t3.small"
  skip_final_snapshot  = false
}