# INFO: Define CloudWatch Alarms for ALB

# INFO: Alert if HTTP 4xx errors are more than threshold value
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm

resource "aws_cloudwatch_metric_alarm" "alb_4xx_errors" {
  alarm_name          = "alb-4xx-errors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  datapoints_to_alarm = 2
  evaluation_periods  = 3
  metric_name         = "HTTPCode_ELB_4XX_Count"
  namespace           = "AWS/ApplicationELB" # NOTE: List of Namespaces: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/aws-services-cloudwatch-metrics.html
  period              = 120
  statistic           = "Sum"
  threshold           = 5 # NOTE: Real world value would be much higher (100, 200?)

  dimensions = {
    //AutoScalingGroupName = aws_autoscaling_group.my_asg.name
    load_balancer_arns = aws_lb.application_load_balancer.arn_suffix
  }

  alarm_description = "This metric monitors ALB HTTP 4xx errors and if they are above 2 in specified evaluation_period, it is going to send a notification email"

  alarm_actions = [aws_sns_topic.myasg_sns_topic.arn]
  ok_actions    = [aws_sns_topic.myasg_sns_topic.arn]
}

# * `metric_name` is NOT DOCUMENTED in the `cloudwatch_metric_alarm` resource documentation! Full list here:
# ? https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-cloudwatch-metrics.html

# * Selected `metric_name` values:

# * Per AppELB Metrics
# ? HTTPCode_ELB_5XX_Count
# ? HTTPCode_ELB_502_Count
# ? TargetResponseTime
# * Per AppELB, per TG Metrics (Useful for LB's with multiple applications and Target Groups)
# ? HTTPCode_Target_4XX_Count
# ? UnHealthyHostCount
# ? HealthyHostCount
# ? TargetResponseTime