variable "eks_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "eks_version" {
  description = "Kubernetes version to use for the EKS cluster (i.e.: 1.27)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster security group will be provisioned"
  type        = string
}

variable "subnet_ids" {
  description = " A list of subnet IDs where the nodes/node groups will be provisioned"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster control plane (ENIs) will be provisioned"
  type        = list(string)
}

variable "karpenter_role" {
  description = "IAM Role of the Karpenter which will be attached to the Nodes"
  type        = string
}

variable "tags" {
  description = "Tags to be associated with the EKS cluster and Services"
  type        = map(any)
  default     = {}
}
