provider "aws" {
  region = "eu-west-3"
}

module "rds" {
  source = "../.."

  # =============================[ General ]=============================
  tags = {
    "name" : "rds-poc-library-one-az",
    "managedByTerraform" : true,
    "port" : 5432,
    "env" : "poc-library"
  }
  aws_region = "eu-west-3"

  # =============================[ RDS Instance ]=============================
  storage_type                       = "gp2"
  vpc_security_group_ids             = ["sg-02dee4462e301497e"]
  identifier                         = "rds-poc-library-one-az"
  instance_class                     = "db.t3.micro"
  allocated_storage                  = 10
  engine                             = "postgres"
  engine_version                     = "13.4"
  db_parameter_family                = "postgres13"
  multi_az                           = false
  performance_insights_enabled       = true
  name                               = "aws_rds_instance_poc_library_one_az"
  username                           = "aws_rds_instance_user_poc_library_one_az"
  backup_retention_period            = 10
  port                               = 5432
  apply_immediately                  = false
  max_allocated_storage              = 20
  subnet_ids                         = ["subnet-0f55d716e3746c4db", "subnet-0ced4e0a55a479422", "subnet-0005a41a2318130e5"]
  rds_secret_recovery_window_in_days = 10
  rds_skip_final_snapshot            = true
  force_ssl                          = false

  custom_kms_key        = false
  custom_kms_key_secret = false
}
