# General
variable "REGION" {
  type    = string
  default = "eu-west-3"
}

variable "PROJECT_TAG" {
  type = string
}

# DEMO_VPC (network, network_data)
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

# Bastion host (bastion_host)
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
