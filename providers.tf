terraform {
  # cloud {
  #   organization = "will-will-org"

  #   workspaces {
  #     name = "terra-house-01"
  #   }
  # }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
}

provider "aws" {
  # Configuration options
}