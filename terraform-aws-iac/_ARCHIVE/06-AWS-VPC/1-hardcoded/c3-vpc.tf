# INFO: Create VPC using Terraform Module
# INFO: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
# INFO: slice Function used for AZ's: https://developer.hashicorp.com/terraform/language/functions/slice

module "vpc" { # NOTE: This is just a name. It can be changed.
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.4.0"

  # INFO: VPC Basic Details
  # NOTE: Details are taken from module examples: https://github.com/terraform-aws-modules/terraform-aws-vpc/blob/master/examples/complete/main.tf

  name = "vpc-dev"
  cidr = "10.0.0.0/16"

  azs              = ["eu-west-2a", "eu-west-2b"]
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24"]

  # INFO: Database subnets
  create_database_subnet_group = true
  create_database_subnet_route_table = true
  create_database_nat_gateway_route = false
  create_database_internet_gateway_route = false
  database_subnets = ["10.0.151.0/24", "10.0.152.0/24"]

  # INFO: NAT Gateways - Outbound Communication
  enable_nat_gateway = true
  single_nat_gateway = true # NOTE: Should be true if you want to provision a single shared NAT Gateway across all of your private networks. Ideally should be false in a Production grade environments for NAT Gateway HA. It is single here to save costs.

  # INFO: VPC DNS Parameters
  enable_dns_hostnames = true
  enable_dns_support = true

  # INFO: TAGS
    public_subnet_tags = {
    Type = "public-subnets"
  }

  private_subnet_tags = {
    Type = "private-subnets"
  }

  database_subnet_tags = {
    Type = "database-subnets"
  }

  tags = {
    Owner = "robk"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-dev"
  }

}