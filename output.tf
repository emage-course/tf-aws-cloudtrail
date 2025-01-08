output "cloudtrail_s3_bucket_name" {
  description = "Name of the S3 bucket used for CloudTrail logs"
  value       = aws_s3_bucket.cloudtrail_bucket.bucket
}

output "cloudtrail_name" {
  description = "CloudTrail Name"
  value       = aws_cloudtrail.developer_trail.name
}

output "sns_topic_arn" {
  description = "SNS Topic ARN for CloudTrail alerts"
  value       = aws_sns_topic.cloudtrail_alerts.arn
}
