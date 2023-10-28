module "eks" {
  source = "../../modules/app/eks"

  eks_name                 = format("%s-%s-%s", var.cluster_name, "cluster", var.env)
  eks_version              = "1.28"
  vpc_id                   = module.vpc.id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.private_subnet_ids
  fargate_subnet_ids       = module.vpc.private_subnet_ids
}
