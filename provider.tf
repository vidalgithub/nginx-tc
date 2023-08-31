terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.12.0"
    }
  }

  # The s3 state backend is already set up under `exosite-temporary-tfstate`
  backend "s3" {
    bucket         = "exosite-temporary-tfstate"
    key            = "tchouetckeatankoua/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
    dynamodb_table = "tflock"
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      "Owner" = "tchouetckeatankoua"
    }
  }
}




