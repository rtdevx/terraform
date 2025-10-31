# INFO: Create Network Load Balancer

# INFO: Create Network Load Balancer - Resource
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "network_load_balancer" {
  name               = "${local.name}-nlb"
  internal           = false
  load_balancer_type = "network"
  //subnets            = [for subnet in aws_subnet.public : subnet.id]
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = local.common_tags

}

# INFO: Network Load Balancer - Target Groups
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

# INFO: APP1
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group" "private_target_group_80_app1" {
  name        = "private-lb-tg-80-app1"
  target_type = "instance"
  port        = 80
  protocol    = "TCP"
  vpc_id      = module.vpc.vpc_id

/*
  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 60 # NOTE: Seconds
  }
*/
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

# INFO: Network Load Balancer - Auto Scaling Target Groups Attach
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment

resource "aws_autoscaling_attachment" "asg_app1" {
  autoscaling_group_name = aws_autoscaling_group.my_asg.id
  lb_target_group_arn    = aws_lb_target_group.private_target_group_80_app1.arn
}

# INFO: network Load Balancer - Listeners
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

/*

# INFO: HTTP

resource "aws_lb_listener" "network_load_balancer_80_redirect" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_target_group_80_app1.arn
  }
}

*/

# INFO: HTTPS Listener

resource "aws_lb_listener" "network_load_balancer_443" {
  depends_on        = [aws_acm_certificate_validation.cert] # NOTE: Must be present due to "Error: creating ELBv2 Listener" (cert validation)
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "443"
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn
  alpn_policy       = "HTTP2Preferred"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_target_group_80_app1.arn
  }
}

/*

# INFO: network Load Balancer - Listener Rules
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule

# INFO: APP1
# * Weighted Forward action

resource "aws_lb_listener_rule" "host_based_routing_app1" {
  listener_arn = aws_lb_listener.network_load_balancer_443.arn
  priority     = 1

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.private_target_group_80_app1.arn
        weight = 100
      }
      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

  condition {
    path_pattern {
      values = ["/app1/*"]
    }
  }
}

*/