terraform {

  # cloud {
  #   organization = "ceeepath"
  #   workspaces {
  #     name = "Terra-House-01"
  #   }
  # }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}

provider "aws" {
  # Configuration options
}