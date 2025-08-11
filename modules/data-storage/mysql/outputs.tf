output "db_address" {
    description = "connect to db via this address"
    value = aws_db_instance.db.address
}

output "db_port" {
    description = "the port of the db"
    value = aws_db_instance.db.port
}