# INFO: Issue and validate TLS Certificate using AWS ACM

# INFO: Most commonly, `acm_certificate` resource is used together with `aws_route53_record` and `aws_acm_certificate_validation` to request a DNS validated certificate, deploy the required validation records and wait for validation to complete.
# ? https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/acm_certificate
# ? https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/route53_record
# ? https://registry.terraform.io/providers/hashicorp/aws/6.15.0/docs/resources/acm_certificate_validation

# INFO: Alternatively, AWS ACM Module can be used:
#? https://registry.terraform.io/modules/terraform-aws-modules/acm/aws/latest

# INFO: Request and validate TLS Certificate using `aws_acm_certificate_validation` resource

resource "aws_acm_certificate" "cert" {
  domain_name               = data.aws_route53_zone.robk_uk.name
  subject_alternative_names = ["app1.${data.aws_route53_zone.robk_uk.name}", "app2.${data.aws_route53_zone.robk_uk.name}"]
  validation_method         = "DNS"
}

/*

data "aws_route53_zone" "robk_uk" {
  name         = data.aws_route53_zone.robk_uk.name
  private_zone = false
}

*/

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = dvo.domain_name == data.aws_route53_zone.robk_uk.name ? data.aws_route53_zone.robk_uk.zone_id : data.aws_route53_zone.robk_uk.zone_id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}