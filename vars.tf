variable "domain_name" {
  description = "The domain name for the certificate"
  type        = string
}

variable "create_logging_bucket" {
  description = "Whether to create a logging bucket"
  type        = bool
  default     = false
}

variable "html_source_git_repo_url" {
  description = "The URL of the Git repository containing the HTML source code"
  type        = string
}

variable "html_source_git_branch" {
  description = "The branch of the Git repository containing the HTML source code"
  type        = string
  default     = "main"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
