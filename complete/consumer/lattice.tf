module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s-%s", "consumer", "vpc-lattice", "sg")
  description = "Managed by Terraform"

  vpc_id = module.vpc.id

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      description              = "Consumer EC2 Security Group"
      source_security_group_id = module.ec2.security_group_id
    }
  ]

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


resource "aws_vpclattice_service_network_vpc_association" "main" {
  vpc_identifier             = module.vpc.id
  service_network_identifier = var.service_network_id
  security_group_ids         = [module.sg.security_group_id]
}
