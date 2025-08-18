provider "aws" {
  region = "us-east-2"
}

module "rds_test" {
  source = "../../../modules/database/rds"
  
  project_name = "test"
  environment  = "dev"
  db_username  = "testuser"
  db_password  = "testpass123"
}