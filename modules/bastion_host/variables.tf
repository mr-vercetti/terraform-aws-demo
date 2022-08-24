variable "VPC_ID" {
  type = string
}

variable "SUBNET_ID" {
  type = string
}

variable "INSTANCE_TYPE" {
  type = string
  default = "t2.micro"
}

variable "INSTANCE_NAME" {
  type = string
}

variable "KEY_NAME" {
  type = string
}