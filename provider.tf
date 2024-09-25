terraform {
  required_providers {
    
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.66.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = "POC"
    }
  }
  profile    = var.profile
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
