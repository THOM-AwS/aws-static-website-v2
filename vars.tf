variable "domain_name" {
  description = "The domain name for the certificate"
  type        = string
}

variable "validation_method" {
  description = "Method for validating the domain name (DNS or EMAIL)"
  type        = string
}

variable "route53_zone_id" {
  description = "The ID of the Route 53 hosted zone to create the validation record in"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "lambda_zip_path" {
  description = "The path to the Lambda zip file"
  type        = string
}

variable "cloudfront_distribution_hosted_zone_id" {
  description = "The hosted zone ID of the CloudFront distribution"
  type        = string
}

variable "create_logging_bucket" {
  description = "Whether to create a logging bucket"
  type        = bool
  default     = false
}
