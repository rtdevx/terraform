# INFO: Define CloudWatch Alarms for Autoscaling Groups

# INFO: Autoscaling - Scaling Policy for High CPU
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy

# NOTE: My understanding is that this policy still requires `Target Tracking Scaling Policy` (defined in c13-06-autoscaling-ttsp.tf)
resource "aws_autoscaling_policy" "high_cpu" {
  name                   = "high-cpu"
  policy_type            = "SimpleScaling"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.my_asg.name
}

# INFO: Cloud Watch Alarm to trigger the above scaling policy when CPU Utilization is above 80%
# INFO: Also send the notificaiton email to users present in SNS Topic Subscription
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_metric_alarm

resource "aws_cloudwatch_metric_alarm" "app1_asg_cwa_cpu" {
  alarm_name          = "App1-ASG-CWA-CPUUtilization"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80 # ? Threshold is applied at 80% avg CPU. How does it correspond with `Target Tracking Scaling Policy` (defined in `c13-06-autoscaling-ttsp.tf` at 50%)? Is this a duplication?

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.my_asg.name
  }

  # NOTE: On Alarm, scale out using above `aws_autoscaling_policy.high_cpu` and send message using SNS
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = [
    aws_autoscaling_policy.high_cpu.arn,
    aws_sns_topic.myasg_sns_topic.arn
  ]

  # NOTE: OK Actions, send message using SNS
  ok_actions = [aws_sns_topic.myasg_sns_topic.arn]

  tags = local.common_tags

}