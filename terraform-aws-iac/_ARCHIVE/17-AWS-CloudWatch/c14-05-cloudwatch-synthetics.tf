# INFO: Generate sswebsite code for Canary

/*
```AWSConsole
CloudWatch > Application Signals (APM) > Synthetics Canaries > Create Canary
```

1. Create a canary manually and copy-paste the generated payload to:

`terraform-aws\sswebsite2\nodejs\node_modules\sswebsite2.js`
*/

# INFO: Create AWS IAM Policy
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy

resource "aws_iam_policy" "cw_canary_iam_policy" {
  name        = "cw-canary-iam-policy"
  path        = "/"
  description = "CloudWatch Canary Synthetic IAM Policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "VisualEditor0",
        "Effect" : "Allow",
        "Action" : "cloudwatch:PutMetricData",
        "Resource" : "*",
        "Condition" : {
          "StringEquals" : {
            "cloudwatch:namespace" : "CloudWatchSynthetics"
          }
        }
      },
      {
        "Sid" : "VisualEditor1",
        "Effect" : "Allow",
        "Action" : [
          "s3:PutObject",
          "logs:CreateLogStream",
          "s3:ListAllMyBuckets",
          "logs:CreateLogGroup",
          "logs:PutLogEvents",
          "s3:GetBucketLocation",
          "xray:PutTraceSegments"
        ],
        "Resource" : "*"
      }
    ]
  })
}

# INFO: AWS IAM Role
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role

/*
resource "aws_iam_role" "cw_canary_iam_role" {
  name                = "cw-canary-iam-role"
  description = "CloudWatch Synthetics lambda execution role for running canaries"
  path = "/service-role/"
  #assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json # (not shown)
  assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}" 
  managed_policy_arns = [aws_iam_policy.cw_canary_iam_policy.arn]
}
*/

resource "aws_iam_role" "cw_canary_iam_role" {
  name               = "cw-canary-iam-role"
  description        = "CloudWatch Synthetics lambda execution role for running canaries"
  path               = "/service-role/"
  assume_role_policy = "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"lambda.amazonaws.com\"},\"Action\":\"sts:AssumeRole\"}]}"
}

# INFO: Attach IAM role to IAM Policy
resource "aws_iam_role_policy_attachment" "cw_canary" {
  role       = aws_iam_role.cw_canary_iam_role.name
  policy_arn = aws_iam_policy.cw_canary_iam_policy.arn
}

# INFO: Create S3 Bucket
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl
resource "aws_s3_bucket" "cw_canary_bucket" {
  bucket = "cw-canary-${random_pet.this.id}"
  #acl    = "private" # UPDATED 
  force_destroy = true

  tags = {
    Name        = local.name
    Environment = local.environment
  }
}

# INFO: Create S3 Bucket Ownership control
resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.cw_canary_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# INFO: Create S3 Bucket ACL
resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.example]
  bucket     = aws_s3_bucket.cw_canary_bucket.id
  acl        = "private"
}

# INFO: AWS CloudWatch Canary
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/synthetics_canary

resource "aws_synthetics_canary" "sswebsite2" {
  name                 = "sswebsite2"
  artifact_s3_location = "s3://${aws_s3_bucket.cw_canary_bucket.id}/sswebsite2"
  execution_role_arn   = aws_iam_role.cw_canary_iam_role.arn
  handler              = "sswebsite2.handler"
  zip_file             = "sswebsite2/sswebsite12v0.zip" # NOTE: UPDATED 251106
  runtime_version      = "syn-nodejs-puppeteer-12.0"    # NOTE: UPDATED 251106
  start_canary         = true

  run_config {
    active_tracing     = true
    memory_in_mb       = 960
    timeout_in_seconds = 60
  }
  schedule {
    expression = "rate(1 minute)"
  }
}

# INFO: AWS CloudWatch Metric Alarm for Synthetics Heart Beat Monitor when availability is less than 10 percent
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm

resource "aws_cloudwatch_metric_alarm" "synthetics_alarm_app1" {
  alarm_name          = "Synthetics-Alarm-App1"
  comparison_operator = "LessThanThreshold"
  datapoints_to_alarm = "2" # "2"
  evaluation_periods  = "3" # "3"
  metric_name         = "SuccessPercent"
  namespace           = "CloudWatchSynthetics"
  period              = "300"
  statistic           = "Average"
  threshold           = "90"
  treat_missing_data  = "breaching" # You can also add "missing"
  dimensions = {
    CanaryName = aws_synthetics_canary.sswebsite2.id
  }
  alarm_description = "Synthetics alarm metric: SuccessPercent LessThanThreshold 90"
  ok_actions        = [aws_sns_topic.myasg_sns_topic.arn]
  alarm_actions     = [aws_sns_topic.myasg_sns_topic.arn]
}

/*
# ! `terraform destroy` does not delete all resources when CloudWatch is deployed. Resources to be deleted manually:
  - Log Groups (CloudWatch > Log Groups)
  - Syntethics Related checks and Lambda functions
*/