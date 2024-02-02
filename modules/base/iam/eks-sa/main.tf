module "irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.30"

  role_name = var.role_name

  attach_vpc_cni_policy = var.attach_vpc_cni_policy
  vpc_cni_enable_ipv4   = var.vpc_cni_enable_ipv4

  oidc_providers = {
    main = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = var.namespaces
    }
  }
}

module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 5.30"

  create_policy = var.create_policy
  policy        = var.policy
  name          = var.policy_name
  description   = var.policy_description

  tags = merge(var.tags, { "Name" = var.policy_name })
}

resource "aws_iam_role_policy_attachment" "attach" {
  count = var.create_policy ? 1 : 0

  role       = module.irsa_role.iam_role_name
  policy_arn = module.iam_policy.arn
}
