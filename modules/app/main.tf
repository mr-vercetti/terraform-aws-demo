resource "aws_security_group" "this" {
  name = "demo-app-autoscaling-group-sg"

  vpc_id = var.VPC_ID

  ingress {
    description = "Self all"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
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

data "template_file" "bootstrap" {
  template = file("${path.module}/resources/bootstrap.sh")
}

resource "aws_launch_configuration" "this" {
  name = "demo-app-launch-configuration"

  image_id      = var.EC2_IMAGE_ID
  instance_type = var.EC2_TYPE

  key_name = var.EC2_KEY_NAME
  security_groups = [aws_security_group.this.id]
  user_data = data.template_file.bootstrap.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name = "demo-app-autoscaling-group"

  min_size         = var.ASG_MIN_SIZE
  max_size         = var.ASG_MAX_SIZE

  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = var.VPC_SUBNETS_IDS
  health_check_type         = "ELB"
  health_check_grace_period = "90"

  tag {
    key                 = "Name"
    value               = "demo-app-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "this" {
  name                   = "demo-app-autoscaling-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.this.name
}