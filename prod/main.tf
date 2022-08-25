provider "aws" {
  profile = "default"
  region  = var.REGION
}

# Create VPC with NAT Gateway and route tables
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.DEMO_VPC_NAME
  cidr = var.DEMO_VPC_CIDR

  azs             = var.DEMO_VPC_AVAILABILITY_ZONES
  private_subnets = var.DEMO_VPC_PRIVATE_SUBNET_CIDRS
  public_subnets  = var.DEMO_VPC_PUBLIC_SUBNET_CIDRS

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
    Project   = var.PROJECT_TAG
  }
}

# Get VPC data
module "vpc_data" {
  depends_on = [module.vpc]
  source     = "../modules/vpc_data"

  VPC_NAME        = var.DEMO_VPC_NAME
  BASTION_HOST_AZ = var.DEMO_BASTION_HOST_AZ
}

# Create bastion host
module "bastion_host" {
  source = "../modules/bastion_host"

  VPC_ID    = module.vpc_data.vpc.id
  SUBNET_ID = module.vpc_data.bastion_host_subnet.id

  INSTANCE_TYPE = var.DEMO_BASTION_HOST_TYPE
  INSTANCE_NAME = var.DEMO_BASTION_HOST_NAME
  KEY_NAME      = var.DEMO_BASTION_HOST_KEY_NAME
}

data "aws_ami" "amazon-linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# Create demo app
module "app" {
  source = "../modules/app"

  VPC_ID          = module.vpc_data.vpc.id
  VPC_SUBNETS_IDS = module.vpc_data.private_subnets.ids

  EC2_IMAGE_ID = data.aws_ami.amazon-linux.id
  EC2_TYPE     = var.DEMO_APP_EC2_TYPE
  EC2_KEY_NAME = var.DEMO_APP_EC2_KEY_NAME

  ASG_MIN_SIZE     = var.DEMO_APP_ASG_MIN_SIZE
  ASG_MAX_SIZE     = var.DEMO_APP_ASG_MAX_SIZE
}
