# INFO: Create EC2 Instance
# INFO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#example-usage
# INFO: First retrieve all available availability zones in the region
#INFO: https://registry.terraform.io/providers/-/aws/latest/docs/data-sources/availability_zones

# INFO: Gather all Availability Zones in your respective Region (as defined in c2-variables.tf)
data "aws_availability_zones" "my_azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# INFO: EC2 Instance
resource "aws_instance" "myec2vm" {
  ami = data.aws_ami.amzlinux2.id
  # NOTE: Referencing List and Map variables
  #instance_type = var.instance_type
  #instance_type = var.instance_type_list[1] # NOTE: Accessing variable of a type "list"
  instance_type = var.instance_type_map["dev"]           # NOTE: Accessing variable of a type "map"
  user_data     = file("${path.module}/app1-install.sh") # NOTE: Apply User Data
  key_name      = var.instance_keypair                   # NOTE: Attach Key-Pair ID
  vpc_security_group_ids = [                             # NOTE: Attach INGRESS SG
    aws_security_group.vpc-ssh.id,
    aws_security_group.vpc-web-80.id,
    aws_security_group.vpc-web-443.id,
    aws_security_group.vpc-egress.id # NOTE: Attach EGRESS SG
  ]

  # NOTE: Create EC2 Instance in all Availabilty Zones of a VPC  
  for_each          = toset(data.aws_availability_zones.my_azones.names)
  availability_zone = each.key # NOTE: You can also use each.value because for list items each.key == each.value

  tags = {
    "Name" = "for_each-Demo-${each.value}"
  }
}