module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = format("%s-%s-%s", var.instance_name, "sg", var.env)
  description = "Security group with all available arguments set (this is just an example)"
  vpc_id      = data.aws_vpc.default.id
}