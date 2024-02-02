variable "bucket_name" {
  description = "The name of the bucket. If omitted, Terraform will assign a random, unique name"
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply"
  type        = string
}

variable "object_ownership" {
  description = "Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter."
  type        = string
}

variable "attach_lb_log" {
  description = "Controls if S3 bucket should have ALB/NLB log delivery policy attached"
  type        = bool
}
