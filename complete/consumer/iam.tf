module "iam" {
  source = "../../modules/base/iam"

  role_name             = format("%s-%s", var.instance_name, "role")
  trusted_role_services = ["ec2.amazonaws.com"]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}
