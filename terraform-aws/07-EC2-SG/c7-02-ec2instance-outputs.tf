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

output "ec2_private_instance_ids" {
  description = "Instance ID of the Private Hosts"
  value = [for ec2private in aws_instance.myec2vm_private : ec2private.id]
}

output "ec2_private_private_ip" {
  description = "Private IP of the Private Hosts"
  value = [for ec2private in aws_instance.myec2vm_private : ec2private.private_ip]
}
