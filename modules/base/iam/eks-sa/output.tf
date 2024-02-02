output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.irsa_role.iam_role_arn
}
