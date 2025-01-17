provider "aws" {
  region = var.region
}

# S3 Bucket to store CloudTrail logs
resource "aws_s3_bucket" "cloudtrail_bucket" {
  bucket        = var.cloudtrail_bucket_name
  force_destroy = true # Enables recursive deletion of all objects in the bucket

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# S3 Bucket Versioning
resource "aws_s3_bucket_versioning" "cloudtrail_versioning" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side Encryption Configuration for S3 Bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail_bucket_encryption" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = aws_s3_bucket.cloudtrail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudTrailWrite",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "${aws_s3_bucket.cloudtrail_bucket.arn}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      },
      {
        Sid    = "AllowS3LogAccess",
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = aws_s3_bucket.cloudtrail_bucket.arn
      }
    ]
  })
}

data "aws_caller_identity" "current" {}

resource "aws_cloudtrail" "developer_trail" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }
}


# CloudWatch Log Group for CloudTrail
resource "aws_cloudwatch_log_group" "trail_log_group" {
  name              = "/aws/cloudtrail/${var.cloudtrail_name}"
  retention_in_days = var.log_retention_days
}

# IAM Role for CloudTrail to push logs to CloudWatch
resource "aws_iam_role" "cloudtrail_role" {
  name = "cloudtrail-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "cloudtrail.amazonaws.com" }
    }]
  })
}

# IAM Policy for CloudTrail Role
resource "aws_iam_policy" "cloudtrail_policy" {
  name        = "cloudtrail-cloudwatch-policy"
  description = "Policy for CloudTrail to push logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "logs:CreateLogStream"
        Resource = "${aws_cloudwatch_log_group.trail_log_group.arn}:*"
      },
      {
        Effect   = "Allow"
        Action   = "logs:PutLogEvents"
        Resource = "${aws_cloudwatch_log_group.trail_log_group.arn}:*"
      }
    ]
  })
}

# Attach Policy to Role
resource "aws_iam_role_policy_attachment" "cloudtrail_attachment" {
  role       = aws_iam_role.cloudtrail_role.name
  policy_arn = aws_iam_policy.cloudtrail_policy.arn
}

# SNS Topic for Alert Notifications
resource "aws_sns_topic" "cloudtrail_alerts" {
  name = "cloudtrail-alerts-topic"
}

# SNS Subscription for Email Notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cloudtrail_alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

# CloudWatch Alarm to Monitor CloudTrail Activity (Unauthorized Activity Example)
resource "aws_cloudwatch_metric_alarm" "unauthorized_activity_alarm" {
  alarm_name          = "unauthorized-activity-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "UnauthorizedOperation"
  namespace           = "AWS/CloudTrail"
  period              = 300
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This alarm triggers when there is unauthorized activity detected in CloudTrail logs."

  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.cloudtrail_alerts.arn]
  ok_actions                = [aws_sns_topic.cloudtrail_alerts.arn]
  insufficient_data_actions = [aws_sns_topic.cloudtrail_alerts.arn]
}

# Optional: CloudWatch Alarm for High Failed API Calls (Example)
resource "aws_cloudwatch_metric_alarm" "failed_api_calls_alarm" {
  alarm_name          = "failed-api-calls-alarm"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FailedAPI"
  namespace           = "AWS/CloudTrail"
  period              = 300
  statistic           = "Sum"
  threshold           = 5
  alarm_description   = "This alarm triggers when there are failed API calls detected in CloudTrail logs."

  actions_enabled           = true
  alarm_actions             = [aws_sns_topic.cloudtrail_alerts.arn]
  ok_actions                = [aws_sns_topic.cloudtrail_alerts.arn]
  insufficient_data_actions = [aws_sns_topic.cloudtrail_alerts.arn]
}
