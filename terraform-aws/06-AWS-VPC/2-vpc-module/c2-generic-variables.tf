# INFO: Input Variables
# INFO: https://developer.hashicorp.com/terraform/language/block/variable

# INFO: AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources will be created"
  type        = string
  default     = "eu-west-2"
}

# INFO: Environment Variable
variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev"
}
# INFO: Business Division
variable "business_divsion" {
  description = "Business Division in the large organization this Infrastructure belongs"
  type        = string
  default     = "SAP"
}

# ! Default values will be overwritten in terraform.tfvars