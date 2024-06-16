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
