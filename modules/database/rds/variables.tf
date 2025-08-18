variable "project_name" {
  description = "Project name for consistent naming"
  type        = string
}

variable "environment" {
  description = "Environment (prod/stage)"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "example_database"
}

variable "allocated_storage" {
  description = "Amount of allocated storage for the database"
  type        = number
  default     = 10
}

variable "instance_class" {
  description = "Instance class for the database"
  type        = string
  default     = "db.t3.micro"
}

variable "skip_final_snapshot" {
  description = "Whether to skip final snapshot when destroying"
  type        = bool
  default     = true
}