resource "aws_vpclattice_service" "main" {
  auth_type = "NONE"
  name      = "app1-service-dev"
}

resource "aws_vpclattice_service_network_service_association" "main" {
  service_identifier         = aws_vpclattice_service.main.id
  service_network_identifier = var.service_network_id
}

resource "aws_vpclattice_listener" "main" {
  name               = "http-80"
  port               = 80
  protocol           = "HTTP"
  service_arn        = aws_vpclattice_service.main.arn
  service_identifier = aws_vpclattice_service.main.id
  default_action {
    forward {
      target_groups {
        target_group_identifier = aws_vpclattice_target_group.main.id
        weight                  = 1
      }
    }
  }
}

resource "aws_vpclattice_target_group" "main" {
  name = "app1-tg-dev"
  type = "ALB"
  config {
    port             = 80
    protocol         = "HTTP"
    protocol_version = "HTTP1"
    vpc_identifier   = module.vpc.id
  }
}

resource "aws_vpclattice_target_group_attachment" "main" {
  target_group_identifier = aws_vpclattice_target_group.main.id

  target {
    id   = module.alb.alb_arn
    port = 80
  }
}
