output "s3_state_bucket" {
  value = module.remote_state.state_bucket.id
}

output "dynamodb_state_lock_table_name" {
  value = module.remote_state.dynamodb_table.name
}

output "kms_state_key_id" {
  value = module.remote_state.kms_key.id
}