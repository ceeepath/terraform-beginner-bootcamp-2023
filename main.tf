terraform {
  required_providers {
    terratowns = {
      source = "local.providers/local/terratowns"
      version = "1.0.0"
    }
  }

  cloud {
    organization = "ceeepath"
    workspaces {
      name = "Terra-Home-01"
    }
  }
}


provider "terratowns" {
  endpoint = var.terratowns_endpoint
  user_uuid= var.teacherseat_user_uuid
  token= var.terratowns_access_token
}

module "football_manager" {
  source = "./modules/terrahouse_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  bucket_name = var.bucket_name
  public_path = var.football_manager.public_path
  content_version = var.football_manager.content_version
}

resource "terratowns_home" "football_manager" {
  name = "Reviving the Red Devils: A Football Manager 2023 Saga"
  description = <<DESCRIPTION
Football Manager 2023 is a simulation game that lets you take 
charge of a football club and lead them to glory.
A die-hard Manchester United fan, Pathfinder, takes charge of his beloved club in Football Manager 2023. 
Frustrated with the team's lackluster performances, he embarks on a virtual journey to transform the club, 
instilling a possession-based style, promoting youth, and making shrewd, budget-friendly signings.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = module.football_manager.cloudfront_domain_name
  town = "missingo"
  content_version = var.football_manager.content_version
}

module "terraform" {
  source = "./modules/terrahouse_aws"
  teacherseat_user_uuid = var.teacherseat_user_uuid
  bucket_name = var.bucket_name
  public_path = var.terraform.public_path
  content_version = var.terraform.content_version
}

resource "terratowns_home" "terraform" {
  name = "Terraform Beginner Bootcamp"
  description = <<DESCRIPTION
Here Andrew is teaching us Terraform by using it to host a website in S3 
Bucket then use a custom provider to provision the website in one of the 
Towns in Terratown.
DESCRIPTION
  #domain_name = module.terrahouse_aws.cloudfront_url
  domain_name = module.terraform.cloudfront_domain_name
  town = "missingo"
  content_version = var.terraform.content_version
}


