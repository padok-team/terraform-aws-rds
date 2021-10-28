# ================================[ General ]===============================

variable "tags" {
  type        = map(any)
  description = "Tags to attach to all resources created by this module"
}

variable "aws_region" {
  type        = string
  default     = "eu-west-3"
  description = "AWS region that will be used for subnets deployments"
}

variable "aws_region_az" {
  type        = list(any)
  default     = ["a", "b"]
  description = "AZ letter list. The module will deploy one subnet per AZ"
}

# =============================[ RDS Instance ]=============================

variable "identifier" {
  type        = string
  description = "Unique identifier for your RDS instance"
}

variable "instance_class" {
  type        = string
  description = "Instance class for your RDS instance"
}

variable "allocated_storage" {
  type        = number
  description = "Storage allocated to your RDS instance"
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
  description = "Set to true to deploy a multi AZ RDS instance"
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Set to true to enable performance insights on your RDS instance"
}

variable "name" {
  type        = string
  description = "Name of your RDS instance"
}

variable "username" {
  type        = string
  description = "Name of the master user for your RDS instance"
}

variable "maintenance_window" {
  type        = string
  default     = "Mon:00:00-Mon:03:00"
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period"
}

variable "port" {
  type        = number
  description = "The port on which the DB accepts connections"
}

variable "apply_immediately" {
  type        = bool
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
}

variable "max_allocated_storage" {
  type        = number
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of VPC subnet IDs to create your db subnet group"
}

variable "rds_skip_final_snapshot" {
  type        = bool
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
}

variable "storage_type" {
  type        = string
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)"
}

# ===========================[ RDS parameter group]========================

variable "db_parameter_family" {
  type        = string
  description = "The family of the DB parameter group"
}

# ===========================[ Use BPI Encryption key ]========================

variable "custom_kms_key" {
  type        = bool
  default     = false
  description = "Set to true to use a custom KMS key. If set to true the module will create KMS Key"
}

variable "arn_custom_kms_key" {
  type        = string
  default     = ""
  description = "Arn of your custom KMS Key. Useful only if custom_kms_key is set to true"
}

# ===============================[ Subnets & VPC ]=========================

variable "vpc_security_group_ids" {
  type        = list(any)
  description = "List of VPC security groups to associate"
}

# ===========================[ RDS Secret settings]========================

variable "rds_secret_recovery_window_in_days" {
  type        = number
  description = "Secret recovery window in days"
}

variable "force_ssl" {
  type        = string
  default     = false
  description = "Force SSL for DB connections"
}

variable "custom_kms_key_secret" {
  type        = bool
  default     = false
  description = "Use a custom KMS key to encrypt secrets"
}
variable "arn_custom_kms_key_secret" {
  type        = string
  default     = null
  description = "Encrypt AWS secret with CMK"
}

variable "password_length" {
  type        = number
  default     = 128
  description = "Password length for db"
}
