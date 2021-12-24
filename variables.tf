
# ================================[ General ]===============================

variable "tags" {
  type        = map(any)
  description = "Tags to attach to all resources created by this module"
}

variable "availability_zone" {
  type        = string
  default     = "eu-west-3a"
  description = "Availability zone to use when Multi AZ is disabled"
}

# =============================[ RDS Instance  ]=============================

variable "identifier" {
  type        = string
  description = "Unique identifier for your RDS instance. For example, aws_rds_instance_postgres_poc_library_break"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "Instance class for your RDS instance"
}

variable "allocated_storage" {
  type        = number
  default     = 10
  description = "Storage allocated to your RDS instance in Gigabytes"
}

variable "engine" {
  type        = string
  description = "Engine used for your RDS instance (mysql, postgres ...)"
}

variable "engine_version" {
  type        = string
  description = "Version of your engine"
}

variable "multi_az" {
  type        = bool
  default     = false
  description = "Set to true to deploy a multi AZ RDS instance"
}

variable "performance_insights_enabled" {
  type        = bool
  default     = true
  description = "Set to true to enable performance insights on your RDS instance"
}

variable "name" {
  type        = string
  default     = "aws_padok_database_instance"
  description = "Name of your database in your RDS instance"
}

variable "username" {
  type        = string
  default     = "admin"
  description = "Name of the master user for the database in your RDS Instance"
}

variable "maintenance_window" {
  type        = string
  default     = "Mon:00:00-Mon:03:00"
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
}

variable "allow_major_version_upgrade" {
  type        = bool
  default     = false
  description = "Indicates that major version upgrades are allowed"

}
variable "backup_retention_period" {
  type        = number
  default     = 30
  description = "Backup retention period"
}

variable "port" {
  type        = number
  default     = null
  description = "The port on which the DB accepts connections. Default is chosen depeding on the engine"
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
}

variable "max_allocated_storage" {
  type        = number
  default     = 50
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs to create your db subnet group"
}

variable "rds_skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
}

variable "storage_type" {
  type        = string
  default     = "gp2"
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
}

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Bool to control if instance is publicly accessible."
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "If the DB instance should have deletion protection enabled. The database can't be deleted when this value is set to true"

}

variable "security_group_id" {
  type        = string
  default     = ""
  description = "(Optional) Security group to apply this rule to."
}

variable "authorized_security_groups" {
  type        = list(string)
  default     = []
  description = "List of the security group that are allowed to access RDS Instance"

}
variable "iam_database_authentication_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"

}

variable "vpc_id" {
  type        = string
  description = "VPC id where the DB is"

}
# ===========================[ RDS parameter group]========================

variable "db_parameter_family" {
  type        = string
  description = "The family of the DB parameter group. Among postgres11, postgres12, postgres13, mysql5.6, mysql5.7, mysql8.0 for MySQL and Postgres"
}

variable "parameters" {
  type = list(object({
    name         = string
    value        = string
    apply_method = string
  }))
  description = "(Optional) List of paramaters to add to the database"
  default     = []
}

# ===========================[ Use existing Encryption key ]========================

variable "arn_custom_kms_key" {
  type        = string
  default     = null
  description = "Arn of your custom KMS Key. Useful only if custom_kms_key is set to true"
}

# ===========================[ RDS Secret settings]========================

variable "rds_secret_recovery_window_in_days" {
  type        = number
  default     = 10
  description = "Secret recovery window in days"
}

variable "force_ssl" {
  type        = string
  default     = true
  description = "Force SSL for DB connections"
}

variable "arn_custom_kms_key_secret" {
  type        = string
  default     = null
  description = "Encrypt AWS secret with CMK"
}

variable "password_length" {
  type        = number
  default     = 40
  description = "Password length for db master user, Minimum length is 25"
}
