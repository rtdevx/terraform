# Input variable definitions
variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "business_division" {
  description = "Business Division"
  type        = string
}

variable "bucket_name_prefix" {
  description = "Name prefix of the S3 bucket."
  type        = string
}

//variable "bucket_name" {
//  description = "Name of the S3 bucket. Must be Unique across AWS."
//  type        = string
//}

variable "tags" {
  description = "Tages to set on the bucket"
  type        = map(string)
  default     = {}
}