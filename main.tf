terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }

    aws = {
      source = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}

provider "random" {
  # Configuration options
}

# Definition for Bucket Name
resource "random_string" "bucket_name" {
  length   = 25
  special  = false
  numeric  = false
  lower    = true
  upper    = false
}


# Creation of S3_Bucket in AWS
resource "aws_s3_bucket" "bucket" {
  bucket = random_string.bucket_name.result
  }


