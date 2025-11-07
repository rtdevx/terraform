# INFO: Input Variables
# INFO: https://developer.hashicorp.com/terraform/language/block/variable

# INFO: AWS Region
variable "aws_region" {
  description = "Region in which AWS Resources will be created"
  type        = string
  default     = "eu-west-2"
}

# INFO: EC2 Instance Type
variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.nano"
}

# INFO: EC2 Instance Key Pair
variable "instance_keypair" {
  description = "EC2 Instance Key Pair associated with EC2 Instance"
  type        = string
  default     = "terraform-key"

}