variable "cluster_name" {
  description = "Name of the ECS Cluster"
  type        = string
}

variable "ecs_service" {
  description = "ECS Service and Container Definition to be associated with the ECS Cluster"
  type        = map(any)
}

variable "tags" {
  description = "Tags to be associated with the ECS cluster and Service"
  type        = map(any)
  default     = {}
}
