provider "aws" {
  profile = "default"
  region  = var.REGION
}

# Create VPC with NAT Gateway and route tables
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = "${var.PROJECT_NAME}-vpc"
  cidr = var.DEMO_VPC_CIDR

  azs             = var.DEMO_VPC_AVAILABILITY_ZONES
  private_subnets = var.DEMO_VPC_PRIVATE_SUBNETS_CIDRS
  public_subnets  = var.DEMO_VPC_PUBLIC_SUBNETS_CIDRS

  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
  }
}

# Get VPC data
module "vpc_data" {
  source     = "../modules/vpc_data"
  depends_on = [module.vpc]

  VPC_NAME        = "${var.PROJECT_NAME}-vpc"
  BASTION_HOST_AZ = var.DEMO_BASTION_HOST_AZ
}

# Get AMI data
module "ami_data" {
  source = "../modules/ami_data"
}

# Create bastion host
module "bastion_host" {
  source = "../modules/bastion_host"

  PROJECT_NAME = var.PROJECT_NAME

  VPC_ID    = module.vpc_data.vpc.id
  SUBNET_ID = module.vpc_data.bastion_host_subnet.id

  EC2_AMI      = module.ami_data.amazon_linux.id
  EC2_TYPE     = var.DEMO_BASTION_HOST_TYPE
  EC2_KEY_NAME = var.DEMO_BASTION_HOST_KEY_NAME
}

# Create ALB
module "alb" {
  source = "../modules/alb"

  PROJECT_NAME = var.PROJECT_NAME

  VPC_ID = module.vpc_data.vpc.id

  ALB_SUBNETS_IDS = module.vpc_data.public_subnets.ids
}

# Create demo app
module "app" {
  source = "../modules/app"

  PROJECT_NAME = var.PROJECT_NAME

  VPC_ID          = module.vpc_data.vpc.id
  VPC_SUBNETS_IDS = module.vpc_data.private_subnets.ids

  EC2_AMI      = module.ami_data.amazon_linux.id
  EC2_TYPE     = var.DEMO_APP_EC2_TYPE
  EC2_KEY_NAME = var.DEMO_APP_EC2_KEY_NAME

  ASG_MIN_SIZE = var.DEMO_APP_ASG_MIN_SIZE
  ASG_MAX_SIZE = var.DEMO_APP_ASG_MAX_SIZE

  ALB_TARGET_GROUP_ARNS = [module.alb.alb_tg.arn]
}
