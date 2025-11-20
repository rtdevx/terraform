resource "aws_s3_bucket" "codepipeline" {
  bucket        = var.codepipeline_bucket_name_prefix
  region        = var.aws_region
  tags          = var.tags
  force_destroy = true
}

resource "aws_s3_bucket_policy" "codepipeline_policy" {
  bucket = aws_s3_bucket.codepipeline.id

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
                "Resource": "arn:aws:s3:::${aws_s3_bucket.codepipeline.id}/*"
            }
        ]
    }
    EOF

}

# INFO: Enable / Disable S3 bucket versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.codepipeline.id
  versioning_configuration {
    status = "Disabled" # Currently not required.
  }
}