provider "aws" {
  region = "us-east-2"
}

module "vpc_test" {
  source = "../../../modules/services/vpc"
  
  project_name = "test"
  environment  = "dev"
}