module "iam" {
  source = "../../modules/base/iam"

  role_name             = format("%s-%s", var.service1_name, "task-role")
  trusted_role_services = ["ecs-tasks.amazonaws.com"]
  custom_role_policy_arns = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
}
