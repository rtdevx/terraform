# INFO: S3 static website bucket

# INFO: Create S3 Bucket
resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  region        = var.aws_region
  tags          = var.tags
  force_destroy = false
}

# INFO: Enable S3 bucket versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Disabled" # Currently not required.
  }
}

# INFO: Set aws_s3_bucket_ownership_controls
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# INFO: Set Bucket policy
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowGetPutAndDeleteObject",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::390157243794:role/MyS3Backend"
                },
                "Action": [
                    "s3:GetObject",
                    "s3:PutObject",
                    "s3:DeleteObject"
                ],
                "Resource": "arn:aws:s3:::${aws_s3_bucket.this.id}/*"
            }
        ]
    }
    EOF
}