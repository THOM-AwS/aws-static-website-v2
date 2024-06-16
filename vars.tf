variable "domain_name" {
  description = "The domain name for the certificate"
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
  default     = "./secheaders.py"
}

variable "create_logging_bucket" {
  description = "Whether to create a logging bucket"
  type        = bool
  default     = false
}
