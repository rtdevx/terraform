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

variable "codepipeline_bucket_name_prefix" {
  description = "CodePipeline Bucket Name Prefix"
  type        = string
}

variable "codepipeline_github_repository" {
  description = "CodePipeline GitHub repository"
  type        = string
}

variable "tags" {
  description = "Tages to set on the bucket"
  type        = map(string)
  default     = {}
}