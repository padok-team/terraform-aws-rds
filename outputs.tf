output "this" {
  description = "RDS Instance"
  value       = aws_db_instance.this
  sensitive   = true
}

output "security_group" {
  description = "Security group of the RDS Instance"
  value       = aws_security_group.this
}

output "db_password_secret_arn" {
  description = "ARN of the database password Secret Manager secret."
  value       = aws_secretsmanager_secret.this.arn
}

output "kms_key_arn" {
  description = "ARN of the database generated KMS Key."
  value       = (var.arn_custom_kms_key == null || var.arn_custom_kms_key_secret == null) ? aws_kms_key.this[0].arn : null
}
