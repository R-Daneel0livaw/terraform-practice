output "build_raw_data_bucket_name" {
  description = "The name of the S3 bucket"
  value       = "build-raw-data"
}

output "directories" {
  value = ["inbound", "waiting", "completed", "archived"]
}
