# Main dev env
terraform {
  required_version = ">= 1.11"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

module "eks" {
  source       = "../../modules/eks"
  cluster_name = "link-shortener"
}

module "vpc" {
  source       = "../../modules/vpc"
  cluster_name = "link-shortener"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["eu-west-2a", "eu-west-2b"]

  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.32.0/19", "10.0.64.0/19"]
}
