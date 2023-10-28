resource "aws_ecs_task_definition" "main" {
  family = "taskdef-${var.ecs_service}"
  container_definitions = jsonencode([
    module.container_definition.json_map_object
  ])
  requires_compatibilities = [var.launch_type]
  cpu                      = var.launch_type == "FARGATE" ? var.task_cpu : null
  memory                   = var.launch_type == "FARGATE" ? var.task_memory : null
  execution_role_arn       = module.iam.iam_role_arn
  task_role_arn            = var.task_role_arn
  network_mode             = var.network_mode

  dynamic "volume" {
    for_each = concat(var.docker_volumes, var.efs_volumes)

    content {
      host_path = lookup(volume.value, "host_path", null)
      name      = volume.value.name

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])

        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", "ENABLED")
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", 2999)

          dynamic "authorization_config" {
            for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", null)
            }
          }
        }
      }
    }
  }

  tags = var.tags
}
