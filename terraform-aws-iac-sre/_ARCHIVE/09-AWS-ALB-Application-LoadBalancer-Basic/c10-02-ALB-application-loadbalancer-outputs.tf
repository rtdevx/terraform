# INFO: LB Outputs

output "id" {
  description = "The ID of the load balancer"
  value       = aws_lb.application_load_balancer.id
}

output "arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.application_load_balancer.arn
}

output "arn_suffix" {
  description = "The ARN Suffix of the load balancer"
  value       = aws_lb.application_load_balancer.arn_suffix
}

output "lb_dns_name" {
  description = "The DNS Name of the load balancer"
  value       = aws_lb.application_load_balancer.dns_name
}

output "zone_id" {
  description = "The zone_id of the load balancer"
  value       = aws_lb.application_load_balancer.zone_id
}

# INFO: Listeners Outputs

output "listeners" {
  description = "Map of listeners created and their attributes"
  value       = aws_lb_listener.application_load_balancer
  //sensitive   = true # NOTE: May or may not be sensitive. Listeners resource is giving diferent outputs than the module, skipping module related outputs.
}

# INFO: Target Groups Outputs

output "target_groups" {
  description = "Map of target groups created and their attributes"
  value       = aws_lb_target_group.private_target_group_80
}