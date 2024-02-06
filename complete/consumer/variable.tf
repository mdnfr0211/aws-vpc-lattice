variable "region" {
  description = "AWS region where the provider will operate"
  type        = string
}

variable "account_ids" {
  description = "List of allowed AWS account IDs to prevent you from mistakenly using an incorrect one"
  type        = list(number)
}

variable "env" {
  description = "Environment"
  type        = string

  validation {
    condition     = can(regex("^dev$|^uat$|^prd$", var.env))
    error_message = "Invalid environment, Must be one of dev|uat|prd"
  }
}

variable "instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "service_network_id" {
  description = "ID of the Shared Service Network"
  type        = string
}
