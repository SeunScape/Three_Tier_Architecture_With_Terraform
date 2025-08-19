provider "aws" {
  region = "us-east-2"
}

locals {
  cluster_name = "myapp"
  environment  = "stage"
  server_port  = 8080
}

module "vpc" {
  source = "../../../modules/services/vpc"
  
  project_name = local.cluster_name
  environment  = local.environment
}

module "security_groups" {
  source = "../../../modules/services/security_group"
  
  project_name = local.cluster_name
  environment  = local.environment
  server_port  = local.server_port
}

module "alb" {
  source = "../../../modules/services/alb"
  
  project_name      = local.cluster_name
  environment       = local.environment
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
}

module "target_group" {
  source = "../../../modules/services/target_group"
  
  project_name = local.cluster_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  server_port  = local.server_port
  listener_arn = module.alb.listener_arn
}

data "terraform_remote_state" "db" {
  backend = "local"
  config = {
    path = "../database/terraform.tfstate"
  }
}

module "asg" {
  source = "../../../modules/services/asg"
  
  project_name       = local.cluster_name
  environment        = local.environment
  subnet_ids         = module.vpc.subnet_ids
  target_group_arns  = [module.target_group.target_group_arn]
  security_group_id  = module.security_groups.instance_security_group_id
  server_port        = local.server_port
  
  db_address = data.terraform_remote_state.db.outputs.db_address
  db_port    = data.terraform_remote_state.db.outputs.db_port
  min_size         = 1
  max_size         = 2
  desired_capacity = 1
  instance_type    = "t2.micro"
}