module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.5.0"

  name = var.alb_name

  load_balancer_type = "application"
  internal           = true
  vpc_id             = var.vpc_id
  subnets            = var.subnet_ids
  security_groups = [
    module.sg.security_group_id
  ]

  access_logs = {
    bucket = var.log_bucket_id
  }

  target_groups = {
    1 = {
      name              = var.tg_name
      backend_protocol  = "HTTP"
      backend_port      = 80
      target_type       = "ip"
      create_attachment = false
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 5
        protocol            = "HTTP"
        matcher             = "200"
      }
    }
  }

  listeners = {
    http = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "1"
      }
    }
  }

  tags = var.tags
}
