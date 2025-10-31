# INFO: Domain Registration
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

resource "aws_route53_record" "nlb" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "nlb-${local.environment}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.network_load_balancer.dns_name
    zone_id                = aws_lb.network_load_balancer.zone_id
    evaluate_target_health = true
  }
}