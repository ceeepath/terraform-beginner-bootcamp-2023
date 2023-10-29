# terraform {

#   # cloud {
#   #   organization = "ceeepath"
#   #   workspaces {
#   #     name = "Terra-House-01"
#   #   }
#   # }

#   required_providers {
#     aws = {
#       source = "hashicorp/aws"
#       version = "5.20.0"
#     }
#   }
# }

# provider "aws" {
#   # Configuration options
# }

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  # Creating the S3 Bucket
  user_uuid   = var.user_uuid
  bucket_name = var.bucket_name

  # Naming documents for static website hosting
  website_files = {
    index = var.website_files.index
    error = var.website_files.error
  }

  # Configuring the S3 Bucket for static website hosting
  file_path = {
    index = var.file_path.index
    error = var.file_path.error
  }
}


