variable "container_name" {
  type        = string
  description = "Name of the ECS Container"
}

variable "container_image" {
  type        = string
  description = "Container Image ID"
}

variable "cw_log_group" {
  type        = string
  description = "Name of the Cloudwatch Log Group in which ECS service logs will be stored"
}

variable "region" {
  type        = string
  description = "Region in which Log Group will be provisioned"
}

variable "secrets" {
  type        = list(map(any))
  description = "Secret stored in Task Definition"
}

variable "environment" {
  type        = list(map(any))
  description = "Environments stored in Task Definition"
}

variable "ecs_service" {
  description = "ECS Service Name to be associated with the ECS Cluster"
  type        = string
}

variable "launch_type" {
  description = "Launch type"
  type        = string
  default     = "FARGATE"
}

variable "task_cpu" {
  description = "Number of cpu units used by the task. If the requires_compatibilities is FARGATE this field is required."
  type        = number
}

variable "task_memory" {
  description = "Amount (in MiB) of memory used by the task. If the requires_compatibilities is FARGATE this field is required."
  type        = number
}

variable "task_role_arn" {
  description = "Task role arn"
  type        = string
}

variable "network_mode" {
  description = "Networking Mode Type"
  type        = string
  default     = "awsvpc"
}

variable "efs_volumes" {
  description = "Task EFS volume definitions as list of configuration objects. You cannot define both Docker volumes and EFS volumes on the same task definition."
  type        = list(any)
}

variable "docker_volumes" {
  description = "Task docker volume definitions as list of configuration objects. You cannot define both Docker volumes and EFS volumes on the same task definition."
  type        = list(any)
}

variable "tags" {
  description = "Tags to be associated with the ECS cluster and Service"
  type        = map(any)
  default     = {}
}
