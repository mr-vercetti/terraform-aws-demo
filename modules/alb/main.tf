resource "aws_security_group" "this" {
  name = "${var.PROJECT_NAME}-alb-sg"

  vpc_id = var.VPC_ID

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "this" {
  name = "${var.PROJECT_NAME}-alb"

  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = var.ALB_SUBNETS_IDS
}

resource "aws_lb_target_group" "this" {
  name     = "${var.PROJECT_NAME}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.VPC_ID

  health_check {
    protocol            = "HTTP"
    port                = 80
    path                = "/healthcheck.html"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 90
    timeout             = 20
  }
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}