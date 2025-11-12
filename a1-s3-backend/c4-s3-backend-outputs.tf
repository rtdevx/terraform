
output "bucket_id" {
  description = "Name (id) of the bucket"
  value       = module.s3_bucket.bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 Bucket"
  value       = module.s3_bucket.bucket_arn
}

output "bucket_domain_name" {
  description = "Bucket Domain Name of the S3 Bucket"
  value       = module.s3_bucket.bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "Regional Domain Name of the S3 Bucket"
  value       = module.s3_bucket.bucket_regional_domain_name
}

output "bucket_region" {
  description = "S3 Bucket Region"
  value       = module.s3_bucket.bucket_region
}