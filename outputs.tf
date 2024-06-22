output "distribution" {
  description = "The CloudFront distribution configuration"
  value       = aws_cloudfront_distribution.this.id
}

output "certificate_arn" {
  description = "The ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "function_arn" {
  description = "The ARN of the Lambda@Edge function"
  value       = aws_lambda_function.cloudfront_lambda.arn
}

output "zone_id" {
  description = "The ID of the Route 53 hosted zone"
  value       = data.aws_route53_zone.selected.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.thiswww.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.thiswww.bucket
}

output "user_name" {
  description = "The name of the IAM user"
  value       = aws_iam_user.this.name
}

output "aws_iam_access_key" {
  description = "The access key of the IAM user"
  value       = aws_iam_access_key.this.id
}

output "aws_iam_access_key_secret" {
  description = "The secret access key of the IAM user. MAKE A NOTE OF THIS NOW, YOU WONT BE ABLE TO SEE IT AGAIN"
  value       = aws_iam_access_key.this.secret
}
