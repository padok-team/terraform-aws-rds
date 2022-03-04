terraform {
  required_version = ">= 1.1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63"
    }
  }
}

provider "aws" {
  region = local.region

  default_tags {
    tags = {
      Env         = local.env
      Region      = local.region
      OwnedBy     = "Padok"
      ManagedByTF = true
    }
  }
}

# some variables to make life easier
locals {

  name   = "basic_private"
  env    = "test"
  region = "eu-west-3"
}

################################################################################
# RDS
################################################################################

module "rds" {
  source = "../.."

  ## GENERAL
  identifier = "rds-poc-library-multi-az"

  ## DATABASE
  engine              = "postgres"
  engine_version      = "13.4"
  db_parameter_family = "postgres13"
  name                = "aws_rds_instance_postgresql_db_poc_library_multi_az"
  username            = "aws_rds_instance_postgresql_user_poc_library_multi_az"

  parameters = [{
    name         = "application_name"
    value        = "mydb"
    apply_method = "immediate"
    },
    {
      name         = "rds.rds_superuser_reserved_connections"
      value        = 4
      apply_method = "pending-reboot"
  }]

  ## NETWORK
  subnet_ids         = module.my_vpc.private_subnets_ids
  vpc_id             = module.my_vpc.vpc_id
  security_group_ids = [aws_security_group.a_basic_security_group.id]
}

# Use this security group to allow access to the RDS instance
# For example by adding your EC2 instance to the security group
resource "aws_security_group" "a_basic_security_group" {
  name        = "a_basic_security_group"
  description = "A example of a security group for my backend"
  vpc_id      = module.my_vpc.vpc_id
}


################################################################################
# Supporting resources
################################################################################

module "my_vpc" {
  source = "git@github.com:padok-team/terraform-aws-network.git"

  vpc_name              = local.name
  vpc_availability_zone = ["eu-west-3a", "eu-west-3b"]

  vpc_cidr            = "10.142.0.0/16"
  public_subnet_cidr  = ["10.142.1.0/28", "10.142.2.0/28"]    # small subnets for natgateway
  private_subnet_cidr = ["10.142.64.0/18", "10.142.128.0/18"] # big subnet for EKS

  single_nat_gateway = true # warning : not for production !

  tags = {
    CostCenter = "Network"
  }
}
