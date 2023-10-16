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

  tags = {
    UserUuid = var.user_uuid
  }
  }


