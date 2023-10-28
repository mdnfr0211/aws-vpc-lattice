module "ecs_cluster" {
  source  = "terraform-aws-modules/ecs/aws//modules/cluster"
  version = "5.2.2"

  cluster_name = var.cluster_name

  tags = merge({
    Name = var.cluster_name
    },
  var.tags)
}

module "ecs_service" {
  source  = "terraform-aws-modules/ecs/aws//modules/service"
  version = "5.2.2"

  for_each = var.ecs_service

  name        = each.value.name
  cluster_arn = module.ecs_cluster.arn

  create_task_definition = false
  task_definition_arn    = each.value.task_definition_arn

  cpu    = each.value.cpu
  memory = each.value.memory

  load_balancer = each.value.load_balancer

  subnet_ids         = each.value.subnet_ids
  security_group_ids = each.value.sg_ids

  tags = merge({
    Name = each.value.name
    },
  var.tags)
}
