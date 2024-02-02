output "alb_arn" {
  description = "ALB ARN"
  value       = module.alb.arn
}

output "target_group_arn" {
  description = "Target group ARN"
  value       = module.alb.target_groups["1"].arn
}
