module "vpc" {
  source = "../../modules/base/vpc"

  vpc_name = format("%s-%s", var.vpc_name, var.env)
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnets = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  private_subnet_tags = {
    "karpenter.sh/discovery" = format("%s-%s-%s", var.cluster_name, "cluster", var.env)
  }
}
