# S3 Backend for my Terraform project's .tfstate file

## Output values

Below values (s3 bucket) will be served as a backend for .tfstate file for any future projects.

- bucket_arn = "arn:aws:s3:::rk-backend"
- bucket_domain_name = "rk-backend.s3.amazonaws.com"
- bucket_id = "rk-backend"
- bucket_region = "eu-west-2"
- bucket_regional_domain_name = "rk-backend.s3.eu-west-2.amazonaws.com"

## Moving terraform backend

For S3 backend for Terraform remote state, use this the root (not a module):

_File:_ `MY_PROJECT/c1-versions.tf`

```shell
# INFO: Terraform Block
# INFO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs#example-usage

terraform {
  required_version = "~> 1.13.0" # NOTE: Greater than 1.13.2. Only the most upright version number (.0) can change.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # NOTE: Greater than 6.0. Only the most upright version number (.0) can change.
    }
  }

  # INFO: S3 Backend Block
  backend "s3" {
    bucket = "rk-backend"
    key    = "envs/prod/s3backend/terraform.tfstate"
    region = "eu-west-2"
    //dynamodb_table = "terraform-locks"
    encrypt = true
  }
}

# INFO: Provider Block
provider "aws" {
  region  = var.aws_region
  profile = "default" # NOTE: AWS Credentials Profile (profile = "default") configured on your local desktop terminal ($HOME/.aws/credentials)
}
```
If needed, terraform backend can be reinitialized with `terraform init --migrate-state` command.

## Bucket Versioning

Bucket versioning is currently NOT REQUIRED, therefore it is disabled at the module level in `a1-s3-backend/modules/aws-s3-backend/main`

If versioning has to be enabled, change the above file accordingly:

```shell
# INFO: Enable S3 bucket versioning
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Disabled" # Currently not required.
  }
}
```