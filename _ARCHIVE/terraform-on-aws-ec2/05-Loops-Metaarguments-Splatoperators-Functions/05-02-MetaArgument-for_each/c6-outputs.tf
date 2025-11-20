# INFO: Terraform Output Values
# INFO: https://developer.hashicorp.com/terraform/language/block/output

# INFO: EC2 Instance Public IP with TOSET
output "latest_splat_instance_publicip" {
  description = "EC2 Instance Public IP"
  #  value       = aws_instance.myec2vm[*].public_ip
  value = [for instance in aws_instance.myec2vm : instance.public_ip]

}

# INFO: EC2 Instance Public DNSwith TOSET
output "latest_splat_instance_publicdns" {
  description = "EC2 Instance Public DNS"
  #  value       = aws_instance.myec2vm[*].public_dns
  value = [for instance in aws_instance.myec2vm : instance.public_dns]
}

# INFO: EC2 Instance Public DNSwith TOMAP
output "instance_splat_instance_publicdns2" {
  description = "value"
  value = {
    for az, instance in aws_instance.myec2vm : az => instance.public_dns
  }

}