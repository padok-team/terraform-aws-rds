locals {
  engine_config = {
    "mysql" : {
      port : 3306,
      force_ssl_rule : "require_secure_transport",
    },
    "postgres" : {
      port : 5432,
      force_ssl_rule : "rds.force_ssl",
    },
    "mariadb" : {
      port : 3306,
      force_ssl_rule : "require_secure_transport"
    },
  }
}

# =============================[ RDS Password ]=============================

resource "random_password" "aws_rds" {
  length      = var.password_length
  special     = false
  upper       = true
  lower       = true
  number      = true
  min_lower   = 15
  min_upper   = 5
  min_numeric = 5
}

resource "aws_secretsmanager_secret" "aws_rds" {
  name                    = "${var.identifier}-password"
  description             = "${var.identifier} RDS password secret"
  recovery_window_in_days = var.rds_secret_recovery_window_in_days
  kms_key_id              = var.arn_custom_kms_key_secret == null ? aws_kms_key.aws_rds.0.arn : var.arn_custom_kms_key_secret
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
      name         = local.engine_config[var.engine].force_ssl_rule
      value        = var.force_ssl ? 1 : 0
      apply_method = "pending-reboot"
    }
  }
}

resource "aws_kms_key" "aws_rds" {
  count                   = var.arn_custom_kms_key == null || var.arn_custom_kms_key_secret == null ? 1 : 0
  description             = "KMS key encryption for ${var.identifier}"
  deletion_window_in_days = 10
}

resource "aws_db_instance" "aws_rds" {

  identifier = var.identifier

  ## STORAGE 
  storage_type          = var.storage_type
  storage_encrypted     = true
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  kms_key_id            = var.arn_custom_kms_key == null ? aws_kms_key.aws_rds.0.arn : var.arn_custom_kms_key

  ## DATABASE
  instance_class       = var.instance_class
  engine               = var.engine
  engine_version       = var.engine_version
  parameter_group_name = aws_db_parameter_group.aws_rds.name
  name                 = var.name
  username             = var.username
  password             = random_password.aws_rds.result

  ## NETWORK
  multi_az                            = var.multi_az
  port                                = var.port != null ? var.port : local.engine_config[var.engine].port
  db_subnet_group_name                = aws_db_subnet_group.aws_rds.id
  availability_zone                   = var.multi_az ? null : var.availability_zone
  vpc_security_group_ids              = [aws_security_group.aws_rds.id]
  publicly_accessible                 = var.publicly_accessible
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  ## MAINTENANCE
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  allow_major_version_upgrade = var.allow_major_version_upgrade
  maintenance_window          = var.maintenance_window
  backup_retention_period     = var.backup_retention_period
  apply_immediately           = var.apply_immediately
  skip_final_snapshot         = var.rds_skip_final_snapshot
  final_snapshot_identifier   = "final-snapshot-${var.identifier}"

  performance_insights_enabled = var.performance_insights_enabled
  deletion_protection          = var.deletion_protection
  tags                         = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_db_subnet_group" "aws_rds" {
  name        = "db-subnet-group-${var.identifier}"
  description = "DB Subnet group for ${var.identifier}"

  subnet_ids = var.subnet_ids
}

resource "aws_security_group" "aws_rds" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier}"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "aws_rds" {
  for_each                 = toset(var.authorized_security_groups)
  security_group_id        = aws_security_group.aws_rds.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.port != null ? var.port : local.engine_config[var.engine].port
  to_port                  = var.port != null ? var.port : local.engine_config[var.engine].port
  source_security_group_id = each.key
}
