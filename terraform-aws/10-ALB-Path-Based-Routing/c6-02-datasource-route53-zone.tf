# INFO: Get Route53 DNS Zone Information
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone.html

# INFO: Data

data "aws_route53_zone" "robk_uk" {
  name         = "iac.robk.uk"
  private_zone = false
}

# INFO: Outputs
# Output robk_uk Zone ID
output "robk_uk_zoneid" { # NOTE: Required for Domain Validation
  description = "The Hosted Zone id of the desired Hosted Zone"
  value       = data.aws_route53_zone.robk_uk.zone_id
}

# Output robk_uk name
output "robk_uk_name" {
  description = " The Hosted Zone name of the desired Hosted Zone."
  value       = data.aws_route53_zone.robk_uk.name
}