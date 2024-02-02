output "bucket_id" {
  value       = module.s3.s3_bucket_id
  description = "Bucket Name/ID"
}

output "bucket_arn" {
  value       = module.s3.s3_bucket_arn
  description = "Bucket ARN"
}

output "bucket_domain" {
  value       = module.s3.s3_bucket_bucket_domain_name
  description = "Bucket Domain Name"
}
