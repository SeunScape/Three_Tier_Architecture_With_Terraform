locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

# Use default VPC - following existing pattern from webserver-cluster
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}