# Call our Custom Terraform Module which we built earlier

module "s3_bucket" {
  source      = "./modules/aws-s3-backend"
  aws_region  = var.aws_region
  bucket_name = "${var.bucket_name}-${local.name}"
  tags        = local.common_tags

}