output "bucket_name" {
  description = "S3 Bucket Name for our static website hosting"
  value       = module.terrahouse_aws.bucket_name
}

output "website_url" {
  description = "Website endpoint"
  value       = module.terrahouse_aws.website_url
}

output "cloudfront_domain_name" {
  description = "Domain name corresponding to the distribution"
  value = module.terrahouse_aws.cloudfront_domain_name
}