# INFO: Create EC2 Instance
# INFO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#example-usage

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
  count = "2" # NOTE: Add count Meta-Argument to create a number of the same resoure type
  tags = {
    "Name"        = "Count Demo ${count.index}" # NOTE: Update the name to reflect "count.index" to iterate
    "Description" = "Variable Lists, Maps and Meta-Arguments"
  }
}