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
    "Name" : "rds-poc-library-multi-az",
    "Port" : 5432,
    "Env" : "poc-library"
  }
  identifier = "rds-poc-library-multi-az"

  ## DATABASE
  engine              = "postgres"
  engine_version      = "13.4"
  db_parameter_family = "postgres13"
  name                = "aws_rds_instance_postgresql_db_poc_library_multi_az"
  username            = "aws_rds_instance_postgresql_user_poc_library_multi_az"

  ## NETWORK
  subnet_ids = ["subnet-0f55d716e3746c4db", "subnet-0ced4e0a55a479422", "subnet-0005a41a2318130e5"]
  vpc_id     = "vpc-0fcea78a178762e3f"

}
