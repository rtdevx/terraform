# INFO: Main DNS name for the LB in the region

output "dns_lb_app1" {
  description = "Load Balancer app1 DNS name"
  value       = aws_route53_record.nlb.name
}