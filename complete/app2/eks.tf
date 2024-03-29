module "eks" {
  source = "../../modules/app/eks"

  eks_name                 = format("%s-%s-%s", var.cluster_name, "cluster", var.env)
  eks_version              = "1.28"
  vpc_id                   = module.vpc.id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.private_subnet_ids
  karpenter_role           = module.karpenter.role_arn
  karpenter_sg             = module.karpenter_node_sg.security_group_id
}
