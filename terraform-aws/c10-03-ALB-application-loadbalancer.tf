# INFO: Create Application Load Balancer - Host Header based Routing

# INFO: Create Application Load Balancer - Resource
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb

resource "aws_lb" "application_load_balancer" {
  name               = "${local.name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.private-web-alb-web-80.id,
    aws_security_group.private-web-alb-web-443.id,
    aws_security_group.private-web-alb-egress.id
  ]

  subnets                    = module.vpc.public_subnets
  enable_deletion_protection = false

  tags = local.common_tags
}

# INFO: Application Load Balancer - Target Groups
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group

# INFO: APP1
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group" "private_target_group_80_app1" {
  name        = "private-lb-tg-80-app1"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 60 # NOTE: Seconds
  }

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

# INFO: APP2
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group" "private_target_group_80_app2" {
  name        = "private-lb-tg-80-app2"
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 60 # NOTE: Seconds
  }

  health_check {
    enabled             = true
    interval            = 30
    path                = "/app2/index.html"
    port                = 80
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }
}

# INFO: APP3 - UMS
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group" "private_target_group_8080_app3" {
  name        = "private-lb-tg-8080-app3"
  target_type = "instance"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id

  stickiness {
    enabled         = true
    type            = "lb_cookie"
    cookie_duration = 60 # NOTE: Seconds
  }

  health_check {
    enabled             = true
    interval            = 30
    path                = "/login"
    port                = 8080
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 6
    protocol            = "HTTP"
    matcher             = "200-399"
  }
}

# INFO: Application Load Balancer - Target Groups Attach
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment

# INFO: APP1
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group_attachment" "private_target_group_80_app1" {

  for_each = {                                      # NOTE: Create Map
    for k, v in aws_instance.myec2vm_private_app1 : # NOTE: k = ec2instance, v = ec2instance_details
    k => v                                          # NOTE: Map ec2instance with ec2instance_details
  }

  target_group_arn = aws_lb_target_group.private_target_group_80_app1.arn
  target_id        = each.value.id
  port             = 80
}

# INFO: APP2
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group_attachment" "private_target_group_80_app2" {

  for_each = {                                      # NOTE: Create Map
    for k, v in aws_instance.myec2vm_private_app2 : # NOTE: k = ec2instance, v = ec2instance_details
    k => v                                          # NOTE: Map ec2instance with ec2instance_details
  }

  target_group_arn = aws_lb_target_group.private_target_group_80_app2.arn
  target_id        = each.value.id
  port             = 80
}

# INFO: APP3 - UMS
# * Only HTTP ports. SSL Termination at LB level. Out of scope for Terraform.

resource "aws_lb_target_group_attachment" "private_target_group_8080_app3" {

  for_each = {                                      # NOTE: Create Map
    for k, v in aws_instance.myec2vm_private_app3 : # NOTE: k = ec2instance, v = ec2instance_details
    k => v                                          # NOTE: Map ec2instance with ec2instance_details
  }

  target_group_arn = aws_lb_target_group.private_target_group_8080_app3.arn
  target_id        = each.value.id
  port             = 8080
}

# INFO: Application Load Balancer - Listeners
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener

# INFO: HTTP => HTTPS Redirect

resource "aws_lb_listener" "application_load_balancer_80_redirect" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {

    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# INFO: HTTPS Listener

resource "aws_lb_listener" "application_load_balancer_443" {
  depends_on        = [aws_acm_certificate_validation.cert] # NOTE: Must be present due to "Error: creating ELBv2 Listener" (cert validation)
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_target_group_8080_app3.arn
  }
}

# INFO: Application Load Balancer - Listener Rules
# ? https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule

# INFO: APP1
# * Weighted Forward action

resource "aws_lb_listener_rule" "host_based_routing_app1" {
  listener_arn = aws_lb_listener.application_load_balancer_443.arn
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

# INFO: APP2
# * Weighted Forward action

resource "aws_lb_listener_rule" "host_based_routing_app2" {
  listener_arn = aws_lb_listener.application_load_balancer_443.arn
  priority     = 2

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.private_target_group_80_app2.arn
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
      values = ["/app2/*"]
    }
  }
}

# INFO: APP3 - UMS
# * Weighted Forward action

resource "aws_lb_listener_rule" "host_based_routing_app3" {
  listener_arn = aws_lb_listener.application_load_balancer_443.arn
  priority     = 3 # ! root context should ALWAYS have highest priority number, otherwilse it will not be evaluated.

  action {
    type = "forward"
    forward {
      target_group {
        arn    = aws_lb_target_group.private_target_group_8080_app3.arn
        weight = 100
      }
      stickiness {
        enabled  = true
        duration = 600
      }
    }
  }

  condition {
    host_header {
      values = ["${aws_route53_record.app3.name}"]
    }
  }
}
