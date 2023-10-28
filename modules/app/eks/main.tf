module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name                   = var.eks_name
  cluster_version                = var.eks_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    kube-proxy = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
    vpc-cni = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
    coredns = {
      configuration_values = jsonencode({
        computeType = "Fargate"
      })
    }
  }

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  create_cluster_security_group = false
  create_node_security_group    = false

  fargate_profiles = merge(
    {
      default = {
        selectors = [
          {
            namespace = "kube-system"
          }
        ]
        subnet_ids = var.fargate_subnet_ids
      },
      karpenter = {
        selectors = [
          {
            namespace = "karpenter"
          }
        ]
      }
      subnet_ids = var.fargate_subnet_ids
    }
  )

  tags = var.tags
}
