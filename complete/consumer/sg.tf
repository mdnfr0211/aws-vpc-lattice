module "alb_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s", var.instance_name, "sg")
  description = "Managed by Terraform"

  vpc_id = data.aws_vpc.main.id

  ingress_with_cidr_blocks = []

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
