module "ecs" {
  source = "../../modules/app/ecs/cluster"

  cluster_name = format("%s-%s", var.cluster_name, var.env)
  ecs_service = {
    service = {
      name                = format("%s-%s", var.service_name, var.env)
      cpu                 = 1024
      memory              = 2048
      task_definition_arn = module.ecs_task["api"].arn
      load_balancer       = {}
      sg_ids = [
        module.sg.security_group_id
      ]
      subnet_ids = module.vpc.private_subnet_ids
    }
  }
}


module "ecs_task" {
  source = "../../modules/app/ecs/container_definition"

  for_each = local.ecs_task

  ecs_service     = each.value.ecs_service
  container_name  = each.value.container_name
  container_image = each.value.container_image
  task_cpu        = each.value.task_cpu
  task_memory     = each.value.task_memory
  docker_volumes  = each.value.docker_volumes
  efs_volumes     = each.value.efs_volumes
  task_role_arn   = each.value.task_role_arn
  cw_log_group    = each.value.cw_log_group
  region          = var.region
  secrets         = each.value.secrets
  environment     = each.value.env
}

module "alb" {
  depends_on = [module.s3]
  source     = "../../modules/app/alb"

  alb_name      = format("%s-%s", var.alb_name, var.env)
  tg_name       = format("%s-%s", var.tg_name, var.env)
  subnet_ids    = module.vpc.private_subnet_ids
  vpc_id        = module.vpc.id
  log_bucket_id = module.s3["alb_log"].bucket_id
}

module "s3" {
  for_each = local.s3_buckets

  source = "../../modules/base/s3"

  bucket_name      = each.value.name
  acl              = each.value.acl
  object_ownership = each.value.object_ownership
  attach_lb_log    = each.value.attach_lb_log
}
