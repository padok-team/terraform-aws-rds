# =============================[ RDS Password ]=============================

resource "random_password" "aws_rds" {
  length  = 128
  special = false
}

resource "aws_secretsmanager_secret" "aws_rds" {
  name                    = "${var.identifier}-password"
  description             = "${var.identifier} RDS password secret"
  recovery_window_in_days = var.rds_secret_recovery_window_in_days
  kms_key_id              = var.custom_kms_key_secret == false ? aws_kms_key.aws_rds.0.arn : var.arn_custom_kms_key_secret
}

resource "aws_secretsmanager_secret_version" "aws_rds" {
  secret_id = aws_secretsmanager_secret.aws_rds.id
  secret_string = jsonencode({
    db_password = random_password.aws_rds.result
  })
}

# =============================[ RDS Instance ]=============================

resource "aws_db_parameter_group" "aws_rds" {
  name   = "${var.identifier}-db-parameter-group"
  family = var.db_parameter_family
  tags   = var.tags
  dynamic "parameter" {
    for_each = var.force_ssl ? { "enabled" : true } : {}
    content {
      name         = "rds.force_ssl"
      value        = var.force_ssl ? 1 : 0
      apply_method = "pending-reboot"
    }
  }
}

resource "aws_kms_key" "aws_rds" {
  count                   = var.custom_kms_key == false ? 1 : 0
  description             = "KMS key encryption for ${var.identifier}"
  deletion_window_in_days = 10
}

resource "aws_db_instance" "aws_rds" {
  storage_type                        = var.storage_type
  kms_key_id                          = var.custom_kms_key == false ? aws_kms_key.aws_rds.0.arn : var.arn_custom_kms_key
  storage_encrypted                   = true
  publicly_accessible                 = false
  iam_database_authentication_enabled = false
  auto_minor_version_upgrade          = true
  allow_major_version_upgrade         = true
  copy_tags_to_snapshot               = false
  maintenance_window                  = var.maintenance_window
  parameter_group_name                = aws_db_parameter_group.aws_rds.name
  password                            = random_password.aws_rds.result
  availability_zone                   = var.multi_az ? null : "${var.aws_region}${var.aws_region_az[0]}"
  vpc_security_group_ids              = var.vpc_security_group_ids
  identifier                          = var.identifier
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  engine                              = var.engine
  engine_version                      = var.engine_version
  multi_az                            = var.multi_az
  performance_insights_enabled        = var.performance_insights_enabled
  name                                = var.name
  username                            = var.username
  backup_retention_period             = var.backup_retention_period
  port                                = var.port
  apply_immediately                   = var.apply_immediately
  max_allocated_storage               = var.max_allocated_storage
  skip_final_snapshot                 = var.rds_skip_final_snapshot
  final_snapshot_identifier           = "final-snapshot-${var.identifier}"
  db_subnet_group_name                = aws_db_subnet_group.aws_rds.id
  tags                                = var.tags

  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_db_parameter_group.aws_rds,
    aws_db_subnet_group.aws_rds
  ]
}

resource "aws_db_subnet_group" "aws_rds" {
  name        = "db-subnet-group-${var.identifier}"
  description = "DB Subnet group for ${var.identifier}"

  subnet_ids = var.subnet_ids
}
