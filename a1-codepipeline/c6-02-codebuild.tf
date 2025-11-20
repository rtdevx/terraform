# INFO: Build CodeBuild Project for Dev Environment

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
    location  = "https://github.com/${var.codepipeline_github_repository}/tree/main"
    buildspec = "buildspec-dev.yml"
  }

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codepipeline.bucket
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/codebuild-tf-iacdevops-aws-dev"
      status = "ENABLED" # NOTE: Enable or DISABLE CloudWatch Logs for CodeBuild Project. Default retention is indefinite! (Delete manualy in CloudWatch > Log Groups).
      //stream_name = "log-stream"
    }
  }

}

# INFO: Build CodeBuild Project for Stag Environment

resource "aws_codebuild_project" "stag" {
  name         = "codebuild-tf-iacdevops-aws-stag"
  description  = "CodeBuild Project for Stag of IAC DevOps Terraform Demo."
  service_role = aws_iam_role.codebuild_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  source {
    type      = "GITHUB"
    location  = "https://github.com/${var.codepipeline_github_repository}/tree/main"
    buildspec = "buildspec-stag.yml"
  }

  artifacts {
    type     = "S3"
    location = aws_s3_bucket.codepipeline.bucket
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/codebuild-tf-iacdevops-aws-stag"
      status = "ENABLED" # NOTE: Enable or DISABLE CloudWatch Logs for CodeBuild Project. Default retention is indefinite! (Delete manualy in CloudWatch > Log Groups).
      //stream_name = "log-stream"
    }
  }

}