# INFO: Domain Registration
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record

/*

resource "aws_route53_record" "app1" {
  zone_id = data.aws_route53_zone.robk_uk.zone_id
  name    = data.aws_route53_zone.robk_uk.name
  type    = "A"

  alias {
    name                   = "app1.${data.aws_route53_zone.robk_uk.name}"
    zone_id                = data.aws_route53_zone.robk_uk.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "app2" {
  zone_id = data.aws_route53_zone.robk_uk.zone_id
  name    = data.aws_route53_zone.robk_uk.name
  type    = "A"

  alias {
    name                   = "app2.${data.aws_route53_zone.robk_uk.name}"
    zone_id                = data.aws_route53_zone.robk_uk.zone_id
    evaluate_target_health = true
  }
}

*/