provider "aws" {
  region = var.REGION
}

provider "aws" {
  alias  = "replica"
  region = var.REGION_REPLICA
}

module "remote_state" {
  source = "nozaq/remote-state-s3-backend/aws"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }

  override_s3_bucket_name = true
  s3_bucket_name          = var.S3_STATE_BUCKET_NAME
  s3_bucket_name_replica  = var.S3_STATE_BUCKET_REPLICA_NAME

  kms_key_alias = var.STATE_KMS_KEY_ALIAS

  dynamodb_table_name = var.STATE_DYNAMODB_TABLE_NAME
}