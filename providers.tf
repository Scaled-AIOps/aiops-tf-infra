terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "scaledaiops-tf-state"
    key     = "infra/terraform.tfstate"
    region  = "eu-central-1"
    profile = "scaledaiops"
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "scaledaiops"
}

# CloudFront requires ACM certs in us-east-1
provider "aws" {
  alias   = "us_east_1"
  region  = "us-east-1"
  profile = "scaledaiops"
}
