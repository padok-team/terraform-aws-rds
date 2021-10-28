# Short description of the use case in comments
terraform {
  required_version = ">= 1.0.9"
  backend "s3" {


    bucket = "library-padok-terraform-state"
    key    = "s3/terraform-rds-multi-az.tfstate"
    region = "eu-west-3"

    dynamodb_table = "library-padok-terraform-lock"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}
provider "aws" {
  region = "eu-west-3"
}

module "rds" {
  source = "../.."

  # =============================[ General ]=============================
  tags = {
    "name" : "rds-poc-library-multi-az",
    "managedByTerraform" : true,
    "port" : 5432,
    "env" : "poc-library"
  }
  aws_region    = "eu-west-3"
  aws_region_az = ["a", "b", "c"]

  # =============================[ RDS Instance ]=============================
  storage_type                       = "gp2"
  vpc_security_group_ids             = ["sg-02dee4462e301497e"]
  identifier                         = "rds-poc-library-multi-az"
  instance_class                     = "db.t3.micro"
  allocated_storage                  = 10
  engine                             = "postgres"
  engine_version                     = "13.4"
  db_parameter_family                = "postgres13"
  multi_az                           = true
  performance_insights_enabled       = true
  name                               = "aws_rds_instance_poc_library_multi_az"
  username                           = "aws_rds_instance_user_poc_library_multi_az"
  backup_retention_period            = 10
  port                               = 5432
  apply_immediately                  = false
  max_allocated_storage              = 20
  subnet_ids                         = ["subnet-0f55d716e3746c4db", "subnet-0ced4e0a55a479422", "subnet-0005a41a2318130e5"]
  rds_secret_recovery_window_in_days = 10
  rds_skip_final_snapshot            = true
  force_ssl                          = true

  custom_kms_key            = true
  arn_custom_kms_key        = "arn:aws:kms:eu-west-3:334033969502:key/32f9b735-8eed-4f91-b94b-5761a7a57b63"
  custom_kms_key_secret     = true
  arn_custom_kms_key_secret = "arn:aws:kms:eu-west-3:334033969502:key/55f3d0a7-0646-4c65-832c-577ad4f10514"
}
