terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.2"
    }
  }
}

# Creating S3 Bucket [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket]
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
  }

# Configuring S3 for Static Website [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration]
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucket.id

  index_document {
    suffix = var.website_files.index
  }

  error_document {
    key = var.website_files.error
  }
}

# Upload website files to S3 Bucket [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object]
resource "aws_s3_object" "file" {
  for_each = var.file_path
  bucket = aws_s3_bucket.bucket.bucket
  key    = "${each.key}.html"
  source = each.value
  etag = filemd5(each.value)
}