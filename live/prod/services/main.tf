provider "aws" {
  region = "us-east-2"
}

locals {
  project_name = "myapp"
  environment  = "prod"
  server_port  = 8080
}

# VPC Module
module "vpc" {
  source = "../../../modules/services/vpc"
  
  project_name = local.project_name
  environment  = local.environment
}

# Security Groups Module
module "security_groups" {
  source = "../../../modules/services/security_group"
  
  project_name = local.project_name
  environment  = local.environment
  server_port  = local.server_port
}

# Application Load Balancer Module
module "alb" {
  source = "../../../modules/services/alb"
  
  project_name      = local.project_name
  environment       = local.environment
  subnet_ids        = module.vpc.subnet_ids
  security_group_id = module.security_groups.alb_security_group_id
}

# Target Group Module
module "target_group" {
  source = "../../../modules/services/target_group"
  
  project_name = local.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
  server_port  = local.server_port
  listener_arn = module.alb.listener_arn
}

# Auto Scaling Group Module
module "asg" {
  source = "../../../modules/services/asg"
  
  project_name       = local.project_name
  environment        = local.environment
  subnet_ids         = module.vpc.subnet_ids
  target_group_arns  = [module.target_group.target_group_arn]
  security_group_id  = module.security_groups.instance_security_group_id
  server_port        = local.server_port
  
  # Production environment settings
  min_size         = 2
  max_size         = 5
  desired_capacity = 3
  instance_type    = "t3.medium"
}