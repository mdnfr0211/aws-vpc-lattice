module "karpenter_sa_role" {
  source = "../../modules/base/iam/eks-sa"

  role_name = format("%s-%s-%s", "karpenter", "sa-role", var.env)

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_provider_arn = module.eks.oidc_provider_arn
  namespaces        = ["karpenter:karpenter"]

  create_policy = true
  policy_name   = format("%s-%s-%s", "karpenter", "sa-policy", var.env)
  policy        = data.aws_iam_policy_document.karpenter.json
}

module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "19.17.2"

  cluster_name           = module.eks.cluster_name
  irsa_oidc_provider_arn = module.eks.oidc_provider_arn

  create_irsa = false

  iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }
}

module "karpenter_node_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s", "karpenter-node", "sg")
  description = "Managed by Terraform"

  vpc_id = module.vpc.id

  ingress_with_source_security_group_id = [
    {
      from_port                = 0
      to_port                  = 0
      protocol                 = -1
      description              = "EKS Cluster Security Group"
      source_security_group_id = module.eks.cluster_primary_security_group_id
    }
  ]

  ingress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "VPC Lattice"
      cidr_blocks = "169.254.171.0/24"
    }
  ]

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

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "v0.33.0"

  set {
    name  = "settings.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter_sa_role.iam_role_arn
  }

  set {
    name  = "settings.interruptionQueueName"
    value = module.karpenter.queue_name
  }
}

resource "kubectl_manifest" "karpenter_nodepool" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1beta1
    kind: NodePool
    metadata:
      name: nginx
    spec:
      limits:
        cpu: 1000
      template:
        metadata:
          labels:
            app: nginx
            provisioner: karpenter
        spec:
          consolidation:
            enabled: true
          nodeClassRef:
            apiVersion: karpenter.k8s.aws/v1beta1
            kind: EC2NodeClass
            name: default
          requirements:
            - key: karpenter.sh/capacity-type
              operator: In
              values:
                - spot
            - key: node.kubernetes.io/instance-type
              operator: In
              values:
                - t3.medium
                - t3.large
                - t3a.medium
                - t3a.large
          taints:
            - key: app
              value: nginx
              effect: NoSchedule
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_nodeclass" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1beta1
    kind: EC2NodeClass
    metadata:
      name: default
    spec:
      amiFamily: Bottlerocket
      role: ${module.karpenter.role_name}
      subnetSelectorTerms:
      - tags:
          karpenter.sh/discovery: ${module.eks.cluster_name}
      securityGroupSelectorTerms:
      - id: ${module.karpenter_node_sg.security_group_id}
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
