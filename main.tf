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
  endpoint = var.terratowns_endpoint
  user_uuid= var.teacherseat_user_uuid
  token= var.terratowns_access_token
}

module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  # Creating the S3 Bucket
  teacherseat_user_uuid = var.teacherseat_user_uuid
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

  # Implementing content versioning for website files
  content_version = var.content_version

  # Uploading Assets to s3 bucket
  assets_path = var.assets_path

}

resource "terratowns_home" "home" {
  name = "How to play Arcanum in 2023"
  description = <<DESCRIPTION
Arcanum is a game from 2001 that shipped with alot of bugs.
Modders have removed all the originals making this game really fun
to play (despite that old look graphics). This is my guide that will
show you how to play arcanum without spoiling the plot.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = module.terrahouse_aws.cloudfront_domain_name
  town = "missingo"
  content_version = 1
}


