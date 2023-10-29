variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = ""
}

variable "eks_default_nodegroup_role_arn" {
  description = "IAM Role ARN of EKS Default Nodegroup"
  type        = list(string)
}

variable "oidc_provider_arn" {
  description = "EKS Cluster OIDC ARN"
  type        = string
}

variable "namespaces" {
  description = "Name of the Kubernetes Namespace in which the serviceaccount resides"
  type        = list(string)
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
