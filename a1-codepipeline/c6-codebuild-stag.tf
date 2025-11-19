resource "aws_codebuild_project" "stag" {
  name         = "MyCodeBuildProject-stag"
  description  = "Build project for Node.js app"
  service_role = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/rtdevx/terraform-iacdevops-with-aws-codepipeline/tree/main"
    buildspec = "buildspec-stag.yml"
  }

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codepipeline.bucket
  }
}