module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = var.azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6                                   = true
  public_subnet_assign_ipv6_address_on_creation = true

  create_egress_only_igw                                        = false
  private_subnet_enable_dns64                                   = false
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

  public_subnet_ipv6_prefixes = [0, 1, 2]

  public_subnet_suffix  = "public"
  private_subnet_suffix = "private"

  igw_tags = {
    Name = format("%s-%s", var.vpc_name, "igw")
  }
}
