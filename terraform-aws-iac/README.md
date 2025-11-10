# terraform
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_website_s3_bucket"></a> [website\_s3\_bucket](#module\_website\_s3\_bucket) | ./modules/aws-s3-static-website-bucket | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | Region in which AWS Resources to be created | `string` | n/a | yes |
| <a name="input_my_s3_bucket"></a> [my\_s3\_bucket](#input\_my\_s3\_bucket) | S3 Bucket name that we pass to S3 Custom Module | `string` | n/a | yes |
| <a name="input_my_s3_tags"></a> [my\_s3\_tags](#input\_my\_s3\_tags) | Tags to set on the bucket | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | ARN of the S3 Bucket |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | Bucket Domain Name of the S3 Bucket |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | Regional Domain Name of the S3 Bucket |
| <a name="output_name"></a> [name](#output\_name) | Name (id) of the bucket |
| <a name="output_static_website_url"></a> [static\_website\_url](#output\_static\_website\_url) | n/a |
<!-- END_TF_DOCS -->