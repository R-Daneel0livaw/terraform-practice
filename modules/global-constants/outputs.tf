output "build_raw_data_bucket_name" {
  description = "The name of the S3 bucket"
  value       = "build-raw-data"
}

output "build_preprocessed_data_bucket_name" {
  description = "The name of the S3 bucket"
  value       = "build-preprocessed-data"
}

output "build_complete_data_bucket_name" {
  description = "The name of the S3 bucket"
  value       = "build-compete-data"
}

output "directories" {
  value = ["inbound", "waiting", "completed", "archived"]
}
