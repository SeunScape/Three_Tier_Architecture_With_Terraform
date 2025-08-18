locals {
  name_prefix = "${var.project_name}-${var.environment}"
}

resource "aws_db_instance" "main" {
  identifier_prefix   = "${local.name_prefix}-db"
  engine              = "mysql"
  allocated_storage   = var.allocated_storage
  instance_class      = var.instance_class
  skip_final_snapshot = var.skip_final_snapshot
  db_name             = var.db_name

  username = var.db_username
  password = var.db_password
}