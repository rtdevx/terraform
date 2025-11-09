# INFO: Create EC2 Instance
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance#example-usage

# EC2 Instance
resource "aws_instance" "myec2vm_private_app3" {
  depends_on    = [module.vpc] # ! Depends on VPC to be created first. Required for NAT GW to be present in order to run user_data.
  ami           = data.aws_ami.amzlinux2.id
  instance_type = var.instance_type_private

  # NOTE: Apply User Data using template function
  user_data = templatefile("${path.module}/app3-ums-install.tftpl", {

    rds_db_address  = aws_db_instance.rdsdb.address
    rds_db_port     = aws_db_instance.rdsdb.port
    rds_db_name     = aws_db_instance.rdsdb.db_name
    rds_db_username = aws_db_instance.rdsdb.username
    rds_db_password = aws_db_instance.rdsdb.password

  })

  key_name = var.instance_keypair # NOTE: Attach Key-Pair ID
  vpc_security_group_ids = [      # NOTE: Attach INGRESS SG

    aws_security_group.private-ssh.id,
    //aws_security_group.private-web-80.id,
    aws_security_group.private-web-8080.id,
    aws_security_group.private-egress.id # NOTE: Attach EGRESS SG

  ]

  count     = var.instance_count_private_app3
  subnet_id = module.vpc.private_subnets[count.index % length(module.vpc.private_subnets)] # NOTE: If var.instance_count_private is greater than the number of subnets, this will cause an index out-of-range error. To avoid that, cycling through subnets using modulo - as advised by copilot

  tags = {
    Name        = "${local.name}-app3-${count.index + 1}" # NOTE: Applied role-specific -suffix for EC2 instance
    owners      = local.owners
    environment = local.environment
  }
}