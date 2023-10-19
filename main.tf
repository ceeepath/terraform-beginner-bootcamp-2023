# Creation of S3_Bucket in AWS
resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
  }


