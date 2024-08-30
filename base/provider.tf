#####################################
### Provider and State information
#####################################
terraform {
  backend "s3" {
    bucket = "terraform-state-quanta-ga"
    key    = "base/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_caller_identity" "aws_account" {}