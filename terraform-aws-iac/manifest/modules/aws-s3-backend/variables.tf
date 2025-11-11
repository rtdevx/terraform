# Input variable definitions
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "eu-west-2"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "business_division" {
  description = "Business Division"
  type        = string
  default     = "training"
}

variable "bucket_name" {
  description = "Name of the S3 bucket. Must be Unique across AWS"
  type        = string
  default     = "s3bucket"
}

variable "tags" {
  description = "Tages to set on the bucket"
  type        = map(string)
  default     = {}
}