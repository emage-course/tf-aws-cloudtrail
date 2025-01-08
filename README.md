This is an example Terraform configuration to set up AWS CloudTrail to monitor IAM account and send alert notifications to an email address using Amazon SNS and CloudWatch Alarms.

To monitor all activities and events of the IAM user, you'll need to add an** ****Event Selector** to the** **`aws_cloudtrail` . This will ensure that CloudTrail captures logs each IAM user. 

* Remember to change the variable alert_email to your email address.

This Terraform code sets up AWS CloudTrail to monitor all activities of IAM users and sends alert notifications to an email address using Amazon SNS and CloudWatch Alarms.

The key resources and components involved are:

1. **S3 Bucket for CloudTrail Logs** : Creates an S3 bucket to store CloudTrail logs with versioning enabled and server-side encryption.
2. **CloudTrail** : Configures AWS CloudTrail to log all activity (including read/write and management events) for the account and stores the logs in the S3 bucket.
3. **IAM Role and Policy for CloudTrail** : Grants CloudTrail permission to write logs to CloudWatch.
4. **CloudWatch Log Group** : Stores CloudTrail logs in a CloudWatch Log Group for further analysis.
5. **CloudWatch Alarms** : Sets up alarms to monitor unauthorized activities and failed API calls based on CloudTrail logs.
6. **SNS Topic for Alerts** : Sends alerts to an SNS topic, which sends notifications to the provided email address.

### Explanation of Resources:

* **S3 Bucket** : Stores CloudTrail logs.
* **CloudTrail** : Tracks API calls made in the AWS account.
* **CloudWatch Log Group** : A group where CloudTrail logs are pushed.
* **CloudWatch Alarms** : Monitors specific activities, such as unauthorized operations or failed API calls.
* **SNS Topic** : Sends alerts to the configured email address when activity thresholds are exceeded.

### Steps for Use:

1. **Update Variables** : Replace** **`var.cloudtrail_bucket_name`,** **`var.cloudtrail_name`,** **`var.environment`, and** **`var.alert_email` with your actual values.
2. **Apply Terraform** :

* Run** **`terraform init` to initialize the working directory.
* Run** **`terraform apply` to create the resources.

The Terraform code provided uses several modules and resources from the AWS provider. Here's a list of the main Terraform modules and resources used:

### 1.** ****aws_s3_bucket**

* **Purpose** : Creates an S3 bucket for storing CloudTrail logs.
* **Module** :** **`aws_s3_bucket`
* **Resources** :** **`aws_s3_bucket`,** **`aws_s3_bucket_versioning`,** **`aws_s3_bucket_server_side_encryption_configuration`,** **`aws_s3_bucket_policy`

### 2.** ****aws_iam_role**

* **Purpose** : Creates an IAM role for CloudTrail to push logs to CloudWatch.
* **Module** :** **`aws_iam_role`
* **Resource** :** **`aws_iam_role`

### 3.** ****aws_iam_policy**

* **Purpose** : Creates an IAM policy for CloudTrail to push logs to CloudWatch.
* **Module** :** **`aws_iam_policy`
* **Resource** :** **`aws_iam_policy`

### 4.** ****aws_iam_role_policy_attachment**

* **Purpose** : Attaches the IAM policy to the IAM role.
* **Module** :** **`aws_iam_role_policy_attachment`
* **Resource** :** **`aws_iam_role_policy_attachment`

### 5.** ****aws_cloudtrail**

* **Purpose** : Configures AWS CloudTrail to log all activities, including management events and read/write events, and stores logs in the S3 bucket.
* **Module** :** **`aws_cloudtrail`
* **Resource** :** **`aws_cloudtrail`

### 6.** ****aws_cloudwatch_log_group**

* **Purpose** : Creates a CloudWatch Log Group to store CloudTrail logs.
* **Module** :** **`aws_cloudwatch_log_group`
* **Resource** :** **`aws_cloudwatch_log_group`

### 7.** ****aws_cloudwatch_metric_alarm**

* **Purpose** : Creates CloudWatch alarms to monitor specific activities, such as unauthorized operations or failed API calls.
* **Module** :** **`aws_cloudwatch_metric_alarm`
* **Resource** :** **`aws_cloudwatch_metric_alarm`

### 8.** ****aws_sns_topic**

* **Purpose** : Creates an SNS topic for alert notifications.
* **Module** :** **`aws_sns_topic`
* **Resource** :** **`aws_sns_topic`

### 9.** ****aws_sns_topic_subscription**

* **Purpose** : Subscribes an email address to the SNS topic for alert notifications.
* **Module** :** **`aws_sns_topic_subscription`
* **Resource** :** **`aws_sns_topic_subscription`

### 10.** ****aws_s3_bucket_acl** (Optional, commented out)

* **Purpose** : Set the ACL for the S3 bucket, if required.
* **Module** :** **`aws_s3_bucket_acl`
* **Resource** :** **`aws_s3_bucket_acl`

### 11.** ****aws_s3_bucket_server_side_encryption_configuration**

* **Purpose** : Configures server-side encryption for the S3 bucket using the AES-256 algorithm.
* **Module** :** **`aws_s3_bucket_server_side_encryption_configuration`
* **Resource** :** **`aws_s3_bucket_server_side_encryption_configuration`

### Summary of Terraform Modules Used:

* **AWS Provider** : The** **`aws` provider is used for interacting with AWS resources.
* **S3 Module** : For creating and managing S3 buckets (`aws_s3_bucket`,** **`aws_s3_bucket_versioning`,** **`aws_s3_bucket_policy`, etc.).
* **IAM Module** : For creating IAM roles and policies (`aws_iam_role`,** **`aws_iam_policy`,** **`aws_iam_role_policy_attachment`).
* **CloudTrail Module** : For setting up CloudTrail (`aws_cloudtrail`).
* **CloudWatch Module** : For managing CloudWatch logs and alarms (`aws_cloudwatch_log_group`,** **`aws_cloudwatch_metric_alarm`).
* **SNS Module** : For creating SNS topics and subscriptions (`aws_sns_topic`,** **`aws_sns_topic_subscription`).

This combination of modules enables monitoring, logging, and alerting for IAM user activities through CloudTrail, CloudWatch, and SNS notifications.
