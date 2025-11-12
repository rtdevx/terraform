# INFO: Call the S3 backend module

module "s3_bucket" {
  source     = "./modules/aws-s3-backend"
  aws_region = var.aws_region
  //bucket_name = "${var.bucket_name_prefix}-${var.environment}"
  bucket_name = var.bucket_name_prefix

  tags = local.common_tags

}