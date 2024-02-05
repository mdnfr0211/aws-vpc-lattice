output "id" {
  description = "ID of the EC2 Instance"
  value       = module.ec2.id
}

output "security_group_id" {
  description = "ID of the Security Group attached to the EC2 Instance"
  value       = module.sg.security_group_id
}
