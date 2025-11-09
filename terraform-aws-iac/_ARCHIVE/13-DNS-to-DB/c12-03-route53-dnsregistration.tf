# INFO: Domain Registration
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

/*
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "${local.environment}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}
*/

resource "aws_route53_record" "app1" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "app1-${local.environment}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app2" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "app2-${local.environment}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app3" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = "app-${local.environment}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.application_load_balancer.dns_name
    zone_id                = aws_lb.application_load_balancer.zone_id
    evaluate_target_health = true
  }
}