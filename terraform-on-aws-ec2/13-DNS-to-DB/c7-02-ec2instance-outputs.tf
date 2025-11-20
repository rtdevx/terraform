# INFO: Bastion Host Outputs

output "ec2_bastion_public_instance_ids" {
  description = "Instance ID of the Bastion Host"
  value       = aws_instance.myec2vm_bastion.id
}

output "ec2_bastion_public_ip" {
  description = "Public IP address of the Bastion Host"
  value       = aws_instance.myec2vm_bastion.public_ip
}

output "ec2_bastion_provate_ip" {
  description = "Private IP address of the Bastion Host"
  value       = aws_instance.myec2vm_bastion.private_ip
}

# INFO: Private Hosts Outputs

# INFO: APP1
output "ec2_private_instance_ids_app1" {
  description = "Instance ID of the Private Hosts"
  value       = [for ec2private_app1 in aws_instance.myec2vm_private_app1 : ec2private_app1.id]
}

output "ec2_private_private_ip_app1" {
  description = "Private IP of the Private Hosts"
  value       = [for ec2private_app1 in aws_instance.myec2vm_private_app1 : ec2private_app1.private_ip]
}

# INFO: APP2
output "ec2_private_instance_ids_app2" {
  description = "Instance ID of the Private Hosts"
  value       = [for ec2private_app2 in aws_instance.myec2vm_private_app2 : ec2private_app2.id]
}

output "ec2_private_private_ip_app2" {
  description = "Private IP of the Private Hosts"
  value       = [for ec2private_app2 in aws_instance.myec2vm_private_app2 : ec2private_app2.private_ip]
}

# INFO: APP3
output "ec2_private_instance_ids_app3" {
  description = "Instance ID of the Private Hosts"
  value       = [for ec2private_app3 in aws_instance.myec2vm_private_app3 : ec2private_app3.id]
}

output "ec2_private_private_ip_app3" {
  description = "Private IP of the Private Hosts"
  value       = [for ec2private_app3 in aws_instance.myec2vm_private_app3 : ec2private_app3.private_ip]
}