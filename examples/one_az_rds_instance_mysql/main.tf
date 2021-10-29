provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = {
      ManagedByTF = true
    }
  }
}

module "rds" {
  source = "../.."

  ## GENERAL
  tags = {
    "Name" : "rds-poc-library-one-az",
    "Port" : 3306,
    "Env" : "poc-library"
  }
  identifier = "rds-poc-library-one-az"

  ## STORAGE
  allocated_storage         = 5
  max_allocated_storage     = 10
  instance_class            = "db.t3.micro"
  arn_custom_kms_key        = "<kms key arn>"
  arn_custom_kms_key_secret = "<kms key arn>"

  ## DATABASE
  engine                       = "mysql"
  engine_version               = "5.7"
  db_parameter_family          = "mysql5.7"
  performance_insights_enabled = false # Performance insight is not supported by MySQL
  name                         = "aws_rds_instance_mysql_db_poc_library_one_az"
  username                     = "aws_mysql_user" # With Mysql username length cannot be greater than 16 characters

  ## NETWORK
  vpc_id     = "vpc-0fcea78a178762e3f"
  subnet_ids = ["subnet-0f55d716e3746c4db", "subnet-0ced4e0a55a479422", "subnet-0005a41a2318130e5"]

  ## MAINTENANCE & BACKUP
  backup_retention_period = 10

}
