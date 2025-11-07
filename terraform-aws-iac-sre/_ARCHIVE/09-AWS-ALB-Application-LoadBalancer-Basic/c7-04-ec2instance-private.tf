# INFO: Create EC2 Instance
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#example-usage

# EC2 Instance
resource "aws_instance" "myec2vm_private" {
  depends_on    = [module.vpc] # ! Depends on VPC to be created first. Required for NAT GW to be present in order to run user_data.
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type_private
  user_data     = file("${path.module}/app1-install.sh") # NOTE: Apply User Data
  key_name      = var.instance_keypair                   # NOTE: Attach Key-Pair ID
  #  subnet_id     = module.vpc.public_subnets[0]
  vpc_security_group_ids = [ # NOTE: Attach INGRESS SG

    aws_security_group.private-ssh.id,
    # * Below SG disabled. Using ALB now.
    aws_security_group.private-web-80.id,
    //aws_security_group.private-web-443.id,
    aws_security_group.private-egress.id # NOTE: Attach EGRESS SG

  ]

  #for_each  = toset(["0", "1"]) # FIX: Number of instances is taken from here, not from vars / tfvars!
  #subnet_id = element(module.vpc.private_subnets, tonumber(each.key))
  count = var.instance_count_private
  #subnet_id = module.vpc.private_subnets[count.index]
  subnet_id = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)] # NOTE: If var.instance_count_private is greater than the number of subnets, this will cause an index out-of-range error. To avoid that, cycling through subnets using modulo - as advised by copilot

  #tags = local.common_tags
  tags = {

    Name        = "${local.name}-VM" # NOTE: Applied role-specific -suffix for EC2 instance
    owners      = local.owners
    environment = local.environment

  }

}