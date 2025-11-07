# INFO: Create EC2 Instance
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#example-usage

# EC2 Instance
resource "aws_instance" "myec2vm_bastion" {
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type_bastion
  user_data     = file("${path.module}/app1-install.sh") # NOTE: Apply User Data
  key_name      = var.instance_keypair                   # NOTE: Attach Key-Pair ID
  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [ # NOTE: Attach INGRESS SG
    aws_security_group.public-bastion-ssh.id,
    aws_security_group.public-bastion-egress.id # NOTE: Attach EGRESS SG
  ]

  #tags = local.common_tags
  tags = {

    Name        = "${local.name}-BastionHost" # NOTE: Applied role-specific -suffix for EC2 instance
    owners      = local.owners
    environment = local.environment

  }

}