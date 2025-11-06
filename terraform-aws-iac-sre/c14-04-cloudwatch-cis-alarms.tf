# INFO: The Center for Internet Security (CIS) Cloudwatch modules
# ? https://registry.terraform.io/modules/terraform-aws-modules/cloudwatch/aws/latest
# ? https://registry.terraform.io/modules/terraform-aws-modules/cloudwatch/aws/latest/submodules/cis-alarms

# INFO: CIS AWS Foundations Benchmark in Security Hub CSPM
# ? https://docs.aws.amazon.com/securityhub/latest/userguide/cis-aws-foundations-benchmark.html

# INFO: Create Log Group for CIS
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group

resource "aws_cloudwatch_log_group" "cis_log_group" {
  name = "cis-log-group-${random_pet.this.id}"
}

# INFO: Define CIS Alarms

module "cloudwatch_cis-alarms" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/cis-alarms"
  version = "5.7.2"
  create  = true

  disabled_controls = ["DisableOrDeleteCMK", "VPCChanges"]
  log_group_name    = aws_cloudwatch_log_group.cis_log_group.name
  alarm_actions     = [aws_sns_topic.myasg_sns_topic.arn]

  tags = local.common_tags

}