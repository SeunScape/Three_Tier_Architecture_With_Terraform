provider "aws" {
    region = "us-east-2"
}

resource "aws_db_instance" "db" {
    identifier_prefix = "${var.db_instance}.db"
    engine = "mysql"
    allocated_storage = 10
    instance_class = "db.t3.micro"
    skip_final_snapshot = true
    db_name = "example_database"

    username = var.db_username
    password = var.db_password
}