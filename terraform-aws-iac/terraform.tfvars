# ! This will overwrite default values from c2-generic-variables.tf

aws_region       = "eu-west-2"
my_s3_bucket    = "mybucket2025"
my_s3_tags      = {
  Terraform = "True"
  Environment = "Dev"
  Project     = "TerraformAWSIaC"
  newtag1 = "tag1"
  newtag2 = "tag2"
}