variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "attach_vpc_cni_policy" {
  description = "Determines whether to attach the VPC CNI IAM policy to the role"
  type        = bool
  default     = false
}

variable "vpc_cni_enable_ipv4" {
  description = "Determines whether to enable IPv4 permissions for VPC CNI policy"
  type        = bool
  default     = false
}

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC ARN"
  type        = string
}

variable "namespaces" {
  description = "Name of the Kubernetes Namespace in which the serviceaccount resides"
  type        = list(string)
}

variable "create_policy" {
  description = "Whether to create the custom policy"
  type        = bool
}

variable "policy_name" {
  description = "The name of the policy"
  type        = string
  default     = ""
}

variable "policy_description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "policy" {
  description = "The path of the policy in IAM (tpl file)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to IAM role resources"
  type        = map(string)
  default     = {}
}
