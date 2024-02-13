resource "aws_vpclattice_service_network" "main" {
  auth_type = "NONE"
  name      = "lattice-service-network-${var.env}"
}

# resource "aws_ram_resource_share" "main" {
#   allow_external_principals = true
#   name                      = "lattice-resource-share"
#   permission_arns           = ["arn:aws:ram::aws:permission/AWSRAMPermissionVpcLatticeServiceNetworkReadWrite"]
# }

# resource "aws_ram_resource_association" "mian" {
#   resource_arn       = aws_vpclattice_service_network.main.arn
#   resource_share_arn = aws_ram_resource_share.main.arn
# }

# resource "aws_ram_principal_association" "main" {
#   for_each           = toset(var.accepter_account_ids)
#   principal          = each.value
#   resource_share_arn = aws_ram_resource_share.main.arn
# }
