resource "aws_lb_target_group" "app" {
  //deregistration_delay = "30"

  health_check {
    enabled             = "true"
    healthy_threshold   = "2"
    interval            = var.interval
    matcher             = "200"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = var.timeout
    unhealthy_threshold = var.unhealthy_threshold
    path                = var.health_check_path
  }

  load_balancing_algorithm_type = "round_robin"
  name                          = "${var.application}-${var.environment}-tg"
  port                          = var.port
  protocol                      = "HTTP"
  slow_start                    = "120"
  target_type                   = "ip"
  vpc_id                        = data.aws_vpc.vpcid.id

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_listener_rule" "http" {

  listener_arn = data.aws_lb_listener.listner.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
  condition {
    path_pattern {
      values = ["/hello"]
    }
  }
}

resource "random_integer" "priority" {
  min = 1
  max = 99
}


resource "aws_alb_listener_rule" "http_cs" {
  count        = var.path_pattern != "" ? 1 : 0
  priority     = random_integer.priority.result
  listener_arn = data.aws_lb_listener.listner.arn
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }
  condition {
    path_pattern {
      values = [var.path_pattern]
    }
  }
}
