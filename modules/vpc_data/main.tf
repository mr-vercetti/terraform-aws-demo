data "aws_vpc" "vpc" {
  tags = {
    Name = var.VPC_NAME
  }
}

data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.VPC_NAME}-private*"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.VPC_NAME}-public*"]
  }
}

data "aws_subnet" "bastion_host_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Name"
    values = ["${var.VPC_NAME}-public-${var.BASTION_HOST_AZ}"]
  }
}