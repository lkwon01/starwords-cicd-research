output "bucket_name" {
  value = aws_s3_bucket.starwords_dev.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.starwords_dev.arn
}
output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.starwords_dev.domain_name
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.starwords_dev.id
