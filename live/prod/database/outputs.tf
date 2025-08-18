output "db_endpoint" {
  description = "RDS instance endpoint"
  value       = module.rds.db_endpoint
}

output "db_port" {
  description = "RDS instance port"
  value       = module.rds.db_port
}

output "db_address" {
  description = "RDS instance address"
  value       = module.rds.db_address
}