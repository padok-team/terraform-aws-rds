output "rds_endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "Endpoint of the RDS Instance"
}

output "rds_identifier" {
  value       = aws_db_instance.this.identifier
  description = "Identifier of the RDS Instance"
}
