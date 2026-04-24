output "rds_endpoint" {
    description = "endpoint of rds"
    value = aws_db_instance.main.endpoint
}

output "rds_port" {
    description = "Port of RDS instance"
    value       = aws_db_instance.main.port
}