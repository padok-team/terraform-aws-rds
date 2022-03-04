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
  identifier = "rds-poc-library-one-az-mariadb"

  ## STORAGE
  allocated_storage     = 5
  max_allocated_storage = 10
  instance_class        = "db.t3.micro"

  ## DATABASE
  engine                       = "mariadb"
  engine_version               = "10.5.13"
  db_parameter_family          = "mariadb10.5"
  performance_insights_enabled = false # Performance insight is not supported by MariaDB
  name                         = "aws_rds_instance_mariadb_db_poc_library_one_az"
  username                     = "aws_mariadbl_user" # With MariaDB username length cannot be greater than 16 characters
  force_ssl                    = false               # force_ssl true does not work with mariadb DB engine

  ## NETWORK
  subnet_ids         = module.my_vpc.private_subnets_ids
  vpc_id             = module.my_vpc.vpc_id
  security_group_ids = [aws_security_group.a_basic_security_group.id]


  ## MAINTENANCE & BACKUP
  backup_retention_period = 10
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
