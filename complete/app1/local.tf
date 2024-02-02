locals {
  ecs_task = {
    api = {
      ecs_service     = var.service_name
      container_name  = "nginx"
      container_image = "nginx:latest"
      task_cpu        = 1024
      task_memory     = 2048
      cw_log_group    = "/aws/ecs/${var.cluster_name}/${var.service_name}"
      docker_volumes  = []
      efs_volumes     = []
      task_role_arn   = module.iam.iam_role_arn
      env             = []
      secrets         = []
    }
  }

  s3_buckets = {
    alb_log = {
      name             = "${var.alb_name}-alb-log"
      object_ownership = "BucketOwnerPreferred"
      acl              = "log-delivery-write"
      attach_lb_log    = true
    }
  }
}
