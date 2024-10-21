resource "aws_s3_bucket" "bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_object" "directories" {
  for_each = toset(var.directories)
  bucket   = aws_s3_bucket.bucket.bucket
  key      = "${each.value}/"
}