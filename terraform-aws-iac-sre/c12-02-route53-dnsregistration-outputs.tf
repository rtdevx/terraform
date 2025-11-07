# INFO: Main DNS name for the LB in the region

/*
output "dns_lb_main" {
  description = "Load Balancer main DNS name"
  value       = aws_route53_record.main.name
}
*/

output "dns_lb_cw" {
  description = "Load Balancer CloudWatch DNS name"
  value       = aws_route53_record.cw.name
}