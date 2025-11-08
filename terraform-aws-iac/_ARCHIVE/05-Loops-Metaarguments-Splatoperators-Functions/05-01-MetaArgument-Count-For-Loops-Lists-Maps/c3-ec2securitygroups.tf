# INFO: Create Ingress Security Group - SSH Traffic
# INFO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#example-usage

resource "aws_security_group" "vpc-ssh" {
  name        = "vpc-ssh"
  description = "Dev VPC SSH"

  tags = {
    Name = "vpc-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc-ssh_ipv4" {
  description       = "Allow Port 22 INBOUND"
  security_group_id = aws_security_group.vpc-ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22

  tags = {
    "Name" = "vpc-ssh-inbound"
  }
}

# INFO: Create Ingress Security Group - WEB Traffic - 80

resource "aws_security_group" "vpc-web-80" {
  name        = "vpc-web-80"
  description = "Dev VPC WEB"

  tags = {
    Name = "vpc-web-80"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc-web-80_ipv4" {
  description       = "Allow Port 80 INBOUND"
  security_group_id = aws_security_group.vpc-web-80.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80

  tags = {
    "Name" = "vpc-web-80-inbound-80"
  }
}

# INFO: Create Ingress Security Group - WEB Traffic - 80

resource "aws_security_group" "vpc-web-443" {
  name        = "vpc-web-443"
  description = "Dev VPC WEB"

  tags = {
    Name = "vpc-web-443"
  }
}

resource "aws_vpc_security_group_ingress_rule" "vpc-web-443_ipv4" {
  description       = "Allow Port 443 INBOUND"
  security_group_id = aws_security_group.vpc-web-443.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443

  tags = {
    "Name" = "vpc-web-443-inbound-443"
  }
}

# INFO: Create Egress Security Group - ALL

resource "aws_security_group" "vpc-egress" {
  name        = "vpc-egress"
  description = "Dev VPC Egress"

  tags = {
    Name = "vpc-egress"
  }
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  description       = "Allow all IP and pports OUTBOUND"
  security_group_id = aws_security_group.vpc-egress.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports

  tags = {
    "Name" = "vpc-all-outbound"
  }
}