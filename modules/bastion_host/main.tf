resource "aws_security_group" "this" {
  name = "${var.PROJECT_NAME}-bastion-host-sg"

  vpc_id = var.VPC_ID

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
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

resource "aws_network_interface" "this" {
  subnet_id       = var.SUBNET_ID
  security_groups = [aws_security_group.this.id]

  tags = {
    Name = "${var.PROJECT_NAME}-bastion-host-nic"
  }
}

resource "aws_instance" "this" {
  ami           = var.EC2_AMI
  instance_type = var.EC2_TYPE
  key_name      = var.EC2_KEY_NAME

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  tags = {
    Name = "${var.PROJECT_NAME}-bastion-host"
  }
}