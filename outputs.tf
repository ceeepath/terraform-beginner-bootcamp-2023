output "cloudfront_domain_name" {
  description = "Domain name corresponding to the distribution"
  value       = module.football_manager.cloudfront_domain_name
}