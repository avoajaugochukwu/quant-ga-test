# Create a bucket with a name that includes the current timestamp
locals {
  bucket_count = 3  # Number of buckets you want to create
}

resource "aws_s3_bucket" "bucket" {
  count = local.bucket_count

  bucket = "tf-bucket-${formatdate("YYYYMMDD-HHMM", timestamp())}-${count.index}"
}

output "bucket_names" {
  value = [for b in aws_s3_bucket.bucket : b.bucket]
}

# output "bucket_arns" {
#   value = [for b in aws_s3_bucket.bucket : b.arn]
# }