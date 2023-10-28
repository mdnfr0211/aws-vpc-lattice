module "container_definition" {
  source          = "cloudposse/ecs-container-definition/aws"
  version         = "0.61.1"
  container_name  = var.container_name
  container_image = var.container_image

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-group" : var.cw_log_group,
      "awslogs-region" : var.region,
      "awslogs-stream-prefix" : "aws",
      "awslogs-create-group" : "true"
    }
    secretOptions = null
  }
  port_mappings = [
    {
      name          = var.container_name
      containerPort = 80
      protocol      = "tcp"
    }
  ]
  secrets      = var.secrets
  mount_points = []

  container_memory_reservation = 128
  environment                  = var.environment
}
