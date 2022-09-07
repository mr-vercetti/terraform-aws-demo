# general
variable "REGION" {
  type = string
}

variable "REGION_REPLICA" {
  type = string
}

variable "S3_STATE_BUCKET_NAME" {
  type = string
}

variable "S3_STATE_BUCKET_REPLICA_NAME" {
  type = string
}

variable "STATE_KMS_KEY_ALIAS" {
  type = string
}

variable "STATE_DYNAMODB_TABLE_NAME" {
  type = string
}