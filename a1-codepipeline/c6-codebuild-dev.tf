resource "aws_codebuild_project" "dev" {
  name         = "codebuild-tf-iacdevops-aws-dev"
  description  = "CodeBuild Project for Dev of IAC DevOps Terraform Demo."
  service_role = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/rtdevx/terraform-iacdevops-with-aws-codepipeline/tree/main"
    buildspec = "buildspec-dev.yml"
  }

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codepipeline.bucket
  }
}