output "rds_endpoint" {
  value       = aws_db_instance.aws_rds.endpoint
  description = "Endpoint of the RDS Instance"
}

output "rds_identifier" {
  value       = aws_db_instance.aws_rds.identifier
  description = "Identifier of the RDS Instance"
}

