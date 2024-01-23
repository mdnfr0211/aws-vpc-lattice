module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s", var.instance_name, "sg")
  description = "Managed by Terraform"

  vpc_id = var.vpc_id

  ingress_with_self                     = []
  ingress_with_cidr_blocks              = []
  ingress_with_prefix_list_ids          = []
  ingress_with_source_security_group_id = []


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
