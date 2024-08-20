# Create a bucket with a name that includes the current timestamp
resource "aws_s3_bucket" "bucket" {
  bucket = "tf-bucket-${timestamp()}"  # Replace "my-bucket" with your desired prefix
}

# Output the bucket name
output "bucket_name" {
  value = aws_s3_bucket.bucket.bucket
}