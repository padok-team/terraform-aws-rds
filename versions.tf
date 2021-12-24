terraform {
  required_version = ">= 0.12.31"
  backend "s3" {


    bucket = "library-padok-terraform-state"
    key    = "s3/terraform.tfstate"
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
