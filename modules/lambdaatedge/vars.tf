variable "domain_name" {
  description = "The domain name of the website"
  type        = string
}

variable "lambda_zip_path" {
  description = "The path to the Lambda zip file"
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
