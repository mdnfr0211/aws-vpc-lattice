module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.5.1"

  name = var.vpc_name
  cidr = var.cidr_range

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  intra_subnets   = var.intra_subnets

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_vpn_gateway = false

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_ipv6                                   = true
  public_subnet_assign_ipv6_address_on_creation = true

  create_egress_only_igw                                        = false
  private_subnet_enable_dns64                                   = false
  private_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

  intra_subnet_enable_dns64                                   = false
  intra_subnet_enable_resource_name_dns_aaaa_record_on_launch = false

  public_subnet_ipv6_prefixes = [0, 1, 2]

  public_subnet_suffix  = "public"
  private_subnet_suffix = "private"
  intra_subnet_suffix   = "intra"

  public_subnet_tags  = {}
  private_subnet_tags = var.private_subnet_tags
  intra_subnet_tags   = var.intra_subnet_tags

  igw_tags = {
    Name = format("%s-%s", var.vpc_name, "igw")
  }

  tags = var.tags
}
