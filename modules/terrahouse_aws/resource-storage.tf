# Creating S3 Bucket [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket]
resource "aws_s3_bucket" "terratown" {
  bucket = var.bucket_name

  tags = {
    UserUuid = var.user_uuid
  }
  }

# Configuring S3 for Static Website [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration]
resource "aws_s3_bucket_website_configuration" "terratown" {
  bucket = aws_s3_bucket.terratown.id

  index_document {
    suffix = var.website_files.index
  }

  error_document {
    key = var.website_files.error
  }
}

# Upload website files to S3 Bucket [https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object]
resource "aws_s3_object" "terratown" {
  for_each = var.file_path
  bucket = aws_s3_bucket.terratown.bucket
  key    = "${each.key}.html"
  source = each.value
  content_type = local.content_type
  etag = filemd5(each.value)
  lifecycle {
    replace_triggered_by = [ terraform_data.content_version.output ]
    ignore_changes = [ etag ]
  }
}

resource "aws_s3_object" "terratown_assets" {
  for_each = fileset(var.assets_path,"*.{jpg,png,gif}")
  bucket = aws_s3_bucket.terratown.bucket
  key    = "assets/${each.key}"
  source = "${var.assets_path}/${each.key}"
  etag = filemd5("${var.assets_path}/${each.key}")
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}


resource "aws_s3_bucket_policy" "terratown" {
  bucket = aws_s3_bucket.terratown.bucket
  #policy = data.aws_iam_policy_document.allow_access_from_another_account.json
  policy = local.policy
}

resource "terraform_data" "content_version" {
  input = var.content_version
}