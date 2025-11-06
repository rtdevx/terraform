# INFO: Target Tracking Scaling Policies
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_policy

# INFO: TTS - Scaling Policy-1: Based on CPU Utilization

resource "aws_autoscaling_policy" "avg_cpu_policy_greater_than_xx" {
  name                      = "avg-cpu-policy-greater-than-xx"
  policy_type               = "TargetTrackingScaling" # NOTE: Default "SimpleScaling."
  estimated_instance_warmup = 300

  autoscaling_group_name = aws_autoscaling_group.my_asg.id

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50.0 # NOTE: CPU Utilization above 50%

  }
}