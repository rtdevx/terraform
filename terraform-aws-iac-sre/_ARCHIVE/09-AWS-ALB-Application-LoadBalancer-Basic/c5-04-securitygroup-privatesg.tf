# INFO: Create Ingress Security Group - SSH Traffic
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#example-usage

resource "aws_security_group" "private-ssh" {
  name        = "private-ssh"
  description = "${local.name} ${local.environment} VPC SSH - PRIVATE"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_ingress_rule" "private-ssh_ipv4" {
  description       = "Allow Port 22 INBOUND from the entire VPC CIDR Block"
  security_group_id = aws_security_group.private-ssh.id
  cidr_ipv4         = var.vpc_cidr # OPTIMIZE: This allows connectivity from the entire VPC CIDR Block. Perhaps restricting SSH access from Bastion Host only would be more preferable?
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = local.common_tags

}

# ! Rules disabled. Using ALB now instead (c5-05-securitygroup-loadbalancersg.tf, c5-02-securitygroup-outputs.tf, c10-*.tf).

# INFO: Create Ingress Security Group - WEB Traffic - 80

resource "aws_security_group" "private-web-80" {
  name        = "private-web-80"
  description = "${local.name} ${local.environment} Dev VPC WEB"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "private-web-80"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private-web-80_ipv4" {
  description       = "Allow Port 80 INBOUND"
  security_group_id = aws_security_group.private-web-80.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    "Name" = "private-web-inbound-80"
  }
}

# INFO: Create Ingress Security Group - WEB Traffic - 443

resource "aws_security_group" "private-web-443" {
  name        = "private-web-443"
  description = "${local.name} ${local.environment} VPC WEB"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "private-web-443"
  }
}

resource "aws_vpc_security_group_ingress_rule" "private-web-443_ipv4" {
  description       = "Allow Port 443 INBOUND"
  security_group_id = aws_security_group.private-web-443.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    "Name" = "private-web-inbound-443"
  }
}

# INFO: Create Egress Security Group - ALL

resource "aws_security_group" "private-egress" {
  name        = "private-egress"
  description = "${local.name} ${local.environment} VPC Egress"
  vpc_id      = module.vpc.vpc_id

  tags = local.common_tags

}

resource "aws_vpc_security_group_egress_rule" "private-allow-all-traffic_ipv4" {
  description       = "Allow all IP and ports OUTBOUND"
  security_group_id = aws_security_group.private-egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = local.common_tags

}

