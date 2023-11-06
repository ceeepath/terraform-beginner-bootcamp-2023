terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }
}

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

provider "terratowns" {
  endpoint = "http://localhost:4567"
  user_uuid="e328f4ab-b99f-421c-84c9-4ccea042c7d1" 
  token="9b49b3fb-b8e9-483c-b703-97ba88eef8e0"
}

# module "terrahouse_aws" {
#   source = "./modules/terrahouse_aws"
#   # Creating the S3 Bucket
#   user_uuid   = var.user_uuid
#   bucket_name = var.bucket_name

#   # Naming documents for static website hosting
#   website_files = {
#     index = var.website_files.index
#     error = var.website_files.error
#   }

#   # Configuring the S3 Bucket for static website hosting
#   file_path = {
#     index = var.file_path.index
#     error = var.file_path.error
#   }

#   # Implementing content versioning for website files
#   content_version = var.content_version

#   # Uploading Assets to s3 bucket
#   assets_path = var.assets_path
# }


