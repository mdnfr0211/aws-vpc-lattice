data "aws_iam_policy_document" "karpenter" {
  statement {
    sid    = "AllowScopedEC2InstanceActions"
    effect = "Allow"

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}::image/*",
      "arn:aws:ec2:${data.aws_region.current.name}::snapshot/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:spot-instances-request/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:security-group/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:subnet/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:launch-template/*",
    ]

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]
  }

  statement {
    sid       = "AllowScopedEC2LaunchTemplateActions"
    effect    = "Allow"
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:*:launch-template/*"]
    actions   = ["ec2:CreateLaunchTemplate"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/provisioner-name"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowScopedEC2InstanceActionsWithTags"
    effect = "Allow"

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:*:fleet/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:instance/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:volume/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:network-interface/*",
    ]

    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/provisioner-name"
      values   = ["*"]
    }
  }

  statement {
    sid    = "AllowScopedResourceCreationTagging"
    effect = "Allow"

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:*:fleet/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:instance/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:volume/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:network-interface/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:launch-template/*",
    ]

    actions = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"

      values = [
        "RunInstances",
        "CreateFleet",
        "CreateLaunchTemplate",
      ]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/provisioner-name"
      values   = ["*"]
    }
  }

  statement {
    sid       = "AllowMachineMigrationTagging"
    effect    = "Allow"
    resources = ["arn:aws:ec2:${data.aws_region.current.name}:*:instance/*"]
    actions   = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/karpenter.sh/managed-by"
      values   = [module.eks.cluster_name]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/karpenter.sh/provisioner-name"
      values   = ["*"]
    }

    condition {
      test     = "ForAllValues:StringEquals"
      variable = "aws:TagKeys"

      values = [
        "karpenter.sh/provisioner-name",
        "karpenter.sh/managed-by",
      ]
    }
  }

  statement {
    sid    = "AllowScopedDeletion"
    effect = "Allow"

    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:*:instance/*",
      "arn:aws:ec2:${data.aws_region.current.name}:*:launch-template/*",
    ]

    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/karpenter.sh/provisioner-name"
      values   = ["*"]
    }
  }

  statement {
    sid       = "AllowRegionalReadActions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [data.aws_region.current.name]
    }
  }

  statement {
    sid       = "AllowGlobalReadActions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "pricing:GetProducts",
      "ssm:GetParameter",
    ]
  }

  statement {
    sid       = "AllowInterruptionQueueActions"
    effect    = "Allow"
    resources = [module.karpenter.queue_arn]

    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage",
    ]
  }

  statement {
    sid       = "AllowPassingInstanceRole"
    effect    = "Allow"
    resources = [module.karpenter.role_arn]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["ec2.amazonaws.com"]
    }
  }

  statement {
    sid       = "AllowAPIServerEndpointDiscovery"
    effect    = "Allow"
    resources = [module.eks.cluster_arn]
    actions   = ["eks:DescribeCluster"]
  }
}

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

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  repository_username = data.aws_ecrpublic_authorization_token.token.user_name
  repository_password = data.aws_ecrpublic_authorization_token.token.password
  chart               = "karpenter"
  version             = "v0.31.1"

  set {
    name  = "settings.aws.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "settings.aws.clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter_sa_role.iam_role_arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = module.karpenter.instance_profile_name
  }

  set {
    name  = "settings.aws.interruptionQueueName"
    value = module.karpenter.queue_name
  }
}

resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: nginx
    spec:
      labels:
        app: nginx
        provisioner: karpenter
      consolidation:
        enabled: true
      limits:
        resources:
          cpu: 1k
      providerRef:
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
    helm_release.karpenter,
    kubectl_manifest.karpenter_node_template
  ]
}

resource "kubectl_manifest" "karpenter_node_template" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: default
    spec:
      subnetSelector:
        karpenter.sh/discovery: ${module.eks.cluster_name}
      securityGroupSelector:
        aws-ids: "${module.eks.cluster_primary_security_group_id}"
  YAML

  depends_on = [
    helm_release.karpenter
  ]
}
