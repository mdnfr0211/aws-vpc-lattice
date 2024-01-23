data "aws_iam_policy_document" "gateway_controller" {
  statement {
    sid    = "AllowScopedVPCActions"
    effect = "Allow"
    resources = [
      "*",
    ]
    actions = [
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeSecurityGroups"
    ]
  }
  statement {
    sid    = "AllowScopedLogsActions"
    effect = "Allow"
    resources = [
      "*",
    ]
    actions = [
      "logs:CreateLogDelivery",
      "logs:GetLogDelivery",
      "logs:UpdateLogDelivery",
      "logs:DeleteLogDelivery",
      "logs:ListLogDeliveries"
    ]
  }
  statement {
    sid    = "AllowScopedLatticeActions"
    effect = "Allow"
    resources = [
      "*",
    ]
    actions = [
      "vpc-lattice:*"
    ]
  }
  statement {
    sid    = "AllowScopedIAMActions"
    effect = "Allow"
    resources = [
      "*",
    ]
    actions = [
      "iam:CreateServiceLinkedRole"
    ]
  }
  statement {
    sid    = "AllowScopedTaggingActions"
    effect = "Allow"
    resources = [
      "*",
    ]
    actions = [
      "tag:GetResources"
    ]
  }
}

module "gateway_controller_sa_role" {
  source = "../../modules/base/iam/eks-sa"

  role_name = format("%s-%s-%s", "gateway-api-controller", "sa-role", var.env)

  oidc_provider_arn = module.eks.oidc_provider_arn
  namespaces        = ["gateway-api-controller:gateway-api-controller"]

  create_policy = true
  policy_name   = format("%s-%s-%s", "gateway-api-controller", "sa-policy", var.env)
  policy        = data.aws_iam_policy_document.gateway_controller.json
}

resource "helm_release" "gateway_controller" {
  namespace        = "gateway-api-controller"
  create_namespace = true

  name       = "gateway-api-controller"
  repository = "oci://public.ecr.aws/aws-application-networking-k8s"
  chart      = "aws-gateway-controller-chart"
  version    = "v1.0.0"

  set {
    name  = "aws.region"
    value = data.aws_region.current.name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.gateway_controller_sa_role.iam_role_arn
  }
}

resource "kubectl_manifest" "gateway_class" {
  yaml_body = <<-YAML
    apiVersion: gateway.networking.k8s.io/v1beta1
    kind: GatewayClass
    metadata:
        name: amazon-vpc-lattice
    spec:
        controllerName: application-networking.k8s.aws/gateway-api-controller
  YAML

  depends_on = [
    helm_release.gateway_controller
  ]
}

resource "kubectl_manifest" "gateway" {
  yaml_body = <<-YAML
    apiVersion: gateway.networking.k8s.io/v1beta1
    kind: Gateway
    metadata:
      name: nginx-gateway
      annotations:
        application-networking.k8s.aws/lattice-vpc-association: "true"
    spec:
      gatewayClassName: amazon-vpc-lattice
      listeners:
      - name: http
        protocol: HTTP
        port: 80
  YAML

  depends_on = [
    helm_release.gateway_controller
  ]
}

resource "kubectl_manifest" "route" {
  yaml_body = <<-YAML
    apiVersion: gateway.networking.k8s.io/v1beta1
    kind: HTTPRoute
    metadata:
      name: nginx-http-route
    spec:
      parentRefs:
      - name: nginx-gateway
        sectionName: http
      rules:
      - backendRefs:
        - name: nginx-service
          namespace: default
          kind: Service
          port: 80
          weight: 100
  YAML

  depends_on = [
    helm_release.gateway_controller
  ]
}
