output "id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnets IDs"
  value       = module.vpc.private_subnets
}
