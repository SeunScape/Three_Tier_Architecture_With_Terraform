variable "project_name" {
  description = "Project name for consistent naming"
  type        = string
}

variable "environment" {
  description = "Environment (prod/stage)"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ASG"
  type        = list(string)
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for instances"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instances"
  type        = string
  default     = "ami-0fb653ca2d3203ac1"
}

variable "instance_type" {
  description = "Instance type for the instances"
  type        = string
  default     = "t2.micro"
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
  default     = 2
}

variable "db_address" {
  description = "Database address for user data"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "Database port for user data"
  type        = number
  default     = 3306
}