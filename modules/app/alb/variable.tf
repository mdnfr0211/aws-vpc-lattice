variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}

variable "tg_name" {
  description = "Name of the Target Group"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "log_bucket_id" {
  type        = string
  description = "S3 log bucket ID"
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags to add"
}
