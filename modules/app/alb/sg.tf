module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s", var.alb_name, "sg")
  description = "Managed by Terraform"

  vpc_id = var.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Ingress - Allow Traffic to Port 80"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "Egress - Allow all traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}
