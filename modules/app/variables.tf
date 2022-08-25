# VPC
variable "VPC_ID" {
  type = string
}

variable "VPC_SUBNETS_IDS" {
  type = list(string)
}

# EC2
variable "EC2_IMAGE_ID" {
  type = string
}

variable "EC2_TYPE" {
  type = string
}

variable "EC2_KEY_NAME" {
  type = string
}

# ASG
variable "ASG_MIN_SIZE" {
  type = number
}

variable "ASG_MAX_SIZE" {
  type = number
}