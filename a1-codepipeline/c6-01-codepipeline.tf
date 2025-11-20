# INFO: Build CodePipeline for Dev Environment

resource "aws_codepipeline" "my_pipeline_dev" {
  name     = "tf-iacdevops-aws-dev"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "arn:aws:codeconnections:us-east-1:390157243794:connection/68b2e3c0-0860-408a-ad8b-fcc2ae60553f"
        FullRepositoryId = "${var.codepipeline_github_repository}"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build-dev"
    action {
      name             = "Build-dev"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output_dev"]
      configuration = {
        ProjectName = aws_codebuild_project.dev.name
      }
    }
  }

}

# INFO: Build CodePipeline for Stag Environment

resource "aws_codepipeline" "my_pipeline_stag" {
  name     = "tf-iacdevops-aws-stag"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = "arn:aws:codeconnections:us-east-1:390157243794:connection/68b2e3c0-0860-408a-ad8b-fcc2ae60553f"
        FullRepositoryId = "${var.codepipeline_github_repository}"
        BranchName       = "main"
      }
    }
  }

  # INFO: Stag environment Build Stage

  stage {
    name = "Build-stag"
    action {
      name             = "Build-stag"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output_stag"]
      configuration = {
        ProjectName = aws_codebuild_project.stag.name
      }
    }
  }

}