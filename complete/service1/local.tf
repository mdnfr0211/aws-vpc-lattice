locals {
  ecs_task = {
    api = {
      ecs_service     = var.service1_name
      container_name  = "test"
      container_image = "nginx"
      task_cpu        = 1024
      task_memory     = 2048
      cw_log_group    = "/aws/ecs/${var.cluster_name}/${var.service1_name}"
      docker_volumes  = []
      efs_volumes     = []
      task_role_arn   = module.iam.iam_role_arn
      env             = []
      secrets         = []
    }
  }
}
