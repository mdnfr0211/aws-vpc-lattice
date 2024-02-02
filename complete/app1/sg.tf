module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s", var.service_name, "sg")
  description = "Managed by Terraform"

  vpc_id = module.vpc.id

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
