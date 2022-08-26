variable "PROJECT_NAME" {
  type = string
}

variable "VPC_ID" {
  type = string
}

variable "SUBNET_ID" {
  type = string
}

variable "EC2_AMI" {
  type = string
}

variable "EC2_TYPE" {
  type    = string
  default = "t2.micro"
}

variable "EC2_KEY_NAME" {
  type = string
}