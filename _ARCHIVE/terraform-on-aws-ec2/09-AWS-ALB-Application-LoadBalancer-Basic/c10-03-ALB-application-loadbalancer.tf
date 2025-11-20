# INFO: Create Application Load Balancer - Basic

# INFO: Create Application Load Balancer - Resource
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "application_load_balancer" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.private-web-alb-web-80.id,
    //aws_security_group.private-web-alb-web-443.id # ! Disabling port 443 (c5-05-securitygroup-loadbalancersg.tf) for now.
    aws_security_group.private-web-alb-egress.id
  ]

  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = local.common_tags

}

# INFO: Application Load Balancer - Target Groups
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

resource "aws_lb_target_group" "private_target_group_80" {
  name        = "private-lb-tg-80"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/app1/index.html"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }

}

# INFO: Application Load Balancer - Target Groups Attach
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment

resource "aws_lb_target_group_attachment" "private_target_group_80" {

  for_each = {                                 # NOTE: Create Map
    for k, v in aws_instance.myec2vm_private : # NOTE: k = ec2instance, v = ec2instance_details
    k => v                                     # NOTE: Map ec2instance with ec2instance_details
  }

  target_group_arn = aws_lb_target_group.private_target_group_80.arn
  target_id        = each.value.id
  port             = 80
}

# INFO: Application Load Balancer - Listeners
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

resource "aws_lb_listener" "application_load_balancer" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_target_group_80.arn
  }
}