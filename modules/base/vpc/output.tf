output "id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "intra_subnet_ids" {
  description = "List of Intra subnet IDs"
  value       = module.vpc.intra_subnets
}
