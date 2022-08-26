resource "aws_security_group" "this" {
  name = "${var.PROJECT_NAME}-autoscaling-group-sg"

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
  name = "${var.PROJECT_NAME}-launch-configuration"

  image_id      = var.EC2_AMI
  instance_type = var.EC2_TYPE

  key_name        = var.EC2_KEY_NAME
  security_groups = [aws_security_group.this.id]
  user_data       = data.template_file.bootstrap.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  name = "${var.PROJECT_NAME}-autoscaling-group"

  min_size = var.ASG_MIN_SIZE
  max_size = var.ASG_MAX_SIZE

  launch_configuration      = aws_launch_configuration.this.name
  vpc_zone_identifier       = var.VPC_SUBNETS_IDS
  health_check_type         = "ELB"
  health_check_grace_period = "90"
  target_group_arns         = var.ALB_TARGET_GROUP_ARNS

  tag {
    key                 = "Name"
    value               = "${var.PROJECT_NAME}-instance"
    propagate_at_launch = true
  }
}

# asg scale up policy
resource "aws_autoscaling_policy" "cpu-policy" {
  name = "${var.PROJECT_NAME}-cpu-policy"

  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm" {
  alarm_name          = "cpu-alarm"
  alarm_description   = "cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.this.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu-policy.arn}"]
}

# asg scale down policy
resource "aws_autoscaling_policy" "cpu-policy-scaledown" {
  name = "${var.PROJECT_NAME}-cpu-policy-scaledown"

  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

resource "aws_cloudwatch_metric_alarm" "cpu-alarm-scaledown" {
  alarm_name          = "cpu-alarm-scaledown"
  alarm_description   = "cpu-alarm-scaledown"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    "AutoScalingGroupName" = "${aws_autoscaling_group.this.name}"
  }

  actions_enabled = true
  alarm_actions   = ["${aws_autoscaling_policy.cpu-policy-scaledown.arn}"]
}