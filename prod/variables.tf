# general
variable "REGION" {
  type    = string
  default = "eu-west-3"
}

variable "PROJECT_TAG" {
  type = string
}

# vpc
variable "DEMO_VPC_NAME" {
  type = string
}

variable "DEMO_VPC_CIDR" {
  type    = string
  default = "10.0.0.0/24"
}

variable "DEMO_VPC_AVAILABILITY_ZONES" {
  type = list(string)
}

variable "DEMO_VPC_PRIVATE_SUBNET_CIDRS" {
  type = list(string)
}

variable "DEMO_VPC_PUBLIC_SUBNET_CIDRS" {
  type = list(string)
}

# bastion host
variable "DEMO_BASTION_HOST_TYPE" {
  type    = string
  default = "t2.micro"
}

variable "DEMO_BASTION_HOST_NAME" {
  type = string
}

variable "DEMO_BASTION_HOST_KEY_NAME" {
  type = string
}

variable "DEMO_BASTION_HOST_AZ" {
  type = string
}

# demo app
variable "DEMO_APP_EC2_TYPE" {
  type = string
}

variable "DEMO_APP_EC2_KEY_NAME" {
  type = string
}

variable "DEMO_APP_ASG_MIN_SIZE" {
  type = number
}

variable "DEMO_APP_ASG_MAX_SIZE" {
  type = number
}