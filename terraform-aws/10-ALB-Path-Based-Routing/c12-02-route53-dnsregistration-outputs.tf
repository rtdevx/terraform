# INFO: Main DNS name for the LB in the region

output "dns_lb_main" {
  description = "Load Balancer main DNS name"
  value       = aws_route53_record.main.name
}

output "dns_lb_app1" {
  description = "Load Balancer app1 DNS name"
  value       = aws_route53_record.app1.name
}

output "dns_lb_app2" {
  description = "Load Balancer app2 DNS name"
  value       = aws_route53_record.app2.name
}