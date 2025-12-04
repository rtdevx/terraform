# INFO: Terraform Block
# INFO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#example-usage

terraform {
  required_version = "~> 1.14.0" # NOTE: Greater than 1.13.2. Only the most upright version number (.0) can change.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # NOTE: Greater than 6.0. Only the most upright version number (.0) can change.
    }
  }
}

# INFO: Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default" # NOTE: AWS Credentials Profile (profile = "default") configured on your local desktop terminal ($HOME/.aws/credentials)
}