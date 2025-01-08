terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # Update to a compatible version
    }
  }
}

variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "cloudtrail_name" {
  description = "Name of the CloudTrail"
  type        = string
  default     = "developer-account-cloudtrail"
}

variable "cloudtrail_bucket_name" {
  description = "S3 bucket name for storing CloudTrail logs"
  type        = string
  default     = "developer-account-cloudtrail-logs"
}

variable "log_retention_days" {
  description = "Retention period for CloudWatch Logs"
  type        = number
  default     = 90
}

variable "alert_email" {
  description = "Email address for receiving alert notifications"
  type        = string
  default     = "solomon.fwilliams@gmail.com"
}

variable "environment" {
  description = "Environment tag for resources"
  type        = string
  default     = "Development"
}
