provider "aws" {
  region = "us-east-2"
}

locals {
  project_name = "myapp"
  environment  = "stage"
}

module "rds" {
  source = "../../../modules/database/rds"
  
  project_name        = local.project_name
  environment         = local.environment
  db_username         = var.db_username
  db_password         = var.db_password
  
  allocated_storage     = 10
  instance_class       = "db.t3.micro"
  skip_final_snapshot  = true
}