locals {
  s3_origin_id = "MyS3Origin"
  content_type = "text/html"
  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = {
      "Sid" = "AllowCloudFrontServicePrincipalReadOnly",
      "Effect" = "Allow",
      "Principal" = {
        "Service" = "cloudfront.amazonaws.com"
      },
      "Action" = "s3:GetObject",
      "Resource" = "arn:aws:s3:::${aws_s3_bucket.terratown.id}/*",
      "Condition" = {
      "StringEquals" = {
          #"AWS:SourceArn": data.aws_caller_identity.terratown.arn
          "AWS:SourceArn" = "arn:aws:cloudfront::${data.aws_caller_identity.terratown.account_id}:distribution/${aws_cloudfront_distribution.terratown.id}"
        }
      }
    }
  })
}