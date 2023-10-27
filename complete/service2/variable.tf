variable "region" {
  description = "AWS region where the provider will operate"
  type        = string
}

variable "account_ids" {
  description = "List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one"
  type        = list(number)
}
