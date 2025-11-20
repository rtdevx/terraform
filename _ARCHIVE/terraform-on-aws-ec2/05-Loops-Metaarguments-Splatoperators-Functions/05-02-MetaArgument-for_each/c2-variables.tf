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

# INFO: Redefining "instance_type" variable to use List and / or Map

# INFO: EC2 Instance Type - List
variable "instance_type_list" {
  description = "EC2 Instance Type(List)"
  type        = list(string)            # NOTE: Define list of strings variable type
  default     = ["t3.nano", "t3.micro"] # NOTE: (Multiple) default values
}

# INFO: EC2 Instance Type - Map
variable "instance_type_map" {
  description = "EC2 Instance Type(Map)"
  type        = map(string) # NOTE: Define map of strings
  default = {
    "dev"  = "t3.nano"  # NOTE: Define default string for dev
    "qa"   = "t3.micro" # NOTE: Define default string for qa
    "prod" = "t3.small" # NOTE: Define default string for prod
  }
}