terraform {
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

# Backend Config
terraform {
  cloud {
    organization = "Kiseki"
    workspaces {
      name = "ecs-app"
    }
  }
}