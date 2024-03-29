locals {
  engine_config = {
    "mysql" : {
      port : 3306,
      force_ssl_rule : "",
    },
    "postgres" : {
      port : 5432,
      force_ssl_rule : "rds.force_ssl",
    },
    "mariadb" : {
      port : 3306,
      force_ssl_rule : ""
    },
  }
}

# =============================[ RDS Password ]=============================

resource "random_password" "this" {
  length      = var.password_length
  special     = false
  upper       = true
  lower       = true
  numeric     = true
  min_lower   = 15
  min_upper   = 5
  min_numeric = 5
}

resource "random_string" "random" {
  length  = 6
  special = false
  upper   = false
}

resource "aws_secretsmanager_secret" "this" {
  name                    = "${var.identifier}-password-${random_string.random.id}"
  description             = "${var.identifier} RDS password secret"
  recovery_window_in_days = var.rds_secret_recovery_window_in_days
  kms_key_id              = var.arn_custom_kms_key_secret == null ? aws_kms_key.this.0.arn : var.arn_custom_kms_key_secret
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = jsonencode({
    db_password = random_password.this.result
  })
}

# =============================[ RDS Instance ]=============================

resource "aws_db_parameter_group" "this" {
  name_prefix = "${var.identifier}-"
  family      = var.db_parameter_family
  dynamic "parameter" {
    for_each = (var.force_ssl && var.engine != "mysql") ? { "enabled" : true } : {}
    content {
      name         = local.engine_config[var.engine].force_ssl_rule
      value        = var.force_ssl ? 1 : 0
      apply_method = "pending-reboot"
    }
  }
  dynamic "parameter" {
    for_each = var.parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
    }
  }
}

resource "aws_kms_key" "this" {
  count                   = var.arn_custom_kms_key == null || var.arn_custom_kms_key_secret == null ? 1 : 0
  description             = "KMS key encryption for ${var.identifier}"
  deletion_window_in_days = 10
}

resource "aws_db_instance" "this" {

  identifier = var.identifier

  ## STORAGE
  storage_type          = var.storage_type
  storage_encrypted     = true
  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  kms_key_id            = var.arn_custom_kms_key == null ? aws_kms_key.this.0.arn : var.arn_custom_kms_key

  ## DATABASE
  instance_class       = var.instance_class
  engine               = var.engine
  engine_version       = var.engine_version
  parameter_group_name = aws_db_parameter_group.this.name
  db_name              = var.name
  username             = var.username
  password             = random_password.this.result

  ## NETWORK
  multi_az                            = var.multi_az
  port                                = var.port != null ? var.port : local.engine_config[var.engine].port
  db_subnet_group_name                = aws_db_subnet_group.this.id
  availability_zone                   = var.multi_az ? null : var.availability_zone
  vpc_security_group_ids              = [aws_security_group.this.id]
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

  lifecycle {
    create_before_destroy = true
  }
}

# Automated cross region backups replication
resource "aws_kms_key" "backups" {
  count = var.cross_region_backup_replication && var.arn_custom_backups_kms_key == null ? 1 : 0

  description             = "KMS key encryption for ${var.identifier} backups"
  deletion_window_in_days = 10

  provider = aws.backups
}

resource "aws_db_instance_automated_backups_replication" "this" {
  count = var.cross_region_backup_replication ? 1 : 0

  source_db_instance_arn = aws_db_instance.this.arn
  retention_period       = 7
  kms_key_id             = var.arn_custom_backups_kms_key == null ? aws_kms_key.backups.0.arn : var.arn_custom_backups_kms_key

  provider = aws.backups
}

resource "aws_db_subnet_group" "this" {
  name        = "db-subnet-group-${var.identifier}"
  description = "DB Subnet group for ${var.identifier}"

  subnet_ids = var.subnet_ids
}

# create a security group for RDS
resource "aws_security_group" "this" {
  name        = "${var.identifier}-sg"
  description = "Security group for ${var.identifier}"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.identifier}-sg"
  }
}

resource "aws_security_group_rule" "these" {
  for_each                 = toset(var.security_group_ids)
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.port != null ? var.port : local.engine_config[var.engine].port
  to_port                  = var.port != null ? var.port : local.engine_config[var.engine].port
  source_security_group_id = each.value
  security_group_id        = aws_security_group.this.id
}
