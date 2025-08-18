variable "project_name" {
  description = "Project name for consistent naming"
  type        = string
}

variable "environment" {
  description = "Environment (prod/stage)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}