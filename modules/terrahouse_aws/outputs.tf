output "bucket_name" {
  value = aws_s3_bucket.terratown.bucket
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.terratown.website_endpoint
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.terratown.domain_name
}