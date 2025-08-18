variable "project_name" {
  description = "Project name for consistent naming"
  type        = string
}

variable "environment" {
  description = "Environment (prod/stage)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the target group will be created"
  type        = string
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
}