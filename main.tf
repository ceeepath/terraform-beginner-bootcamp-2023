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
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}


