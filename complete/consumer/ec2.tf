module "ec2" {
  source = "../../modules/app/ec2"

  instance_name        = format("%s-%s", var.instance_name, var.env)
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = "t3a.micro"
  availability_zone    = slice(data.aws_availability_zones.available.names, 0, 3)[0]
  subnet_id            = var.subnet_id
  sg_ids               = [
    module.sg.security_group_id
  ]
  iam_instance_profile = ""
  ebs_volumes          = {}
  kms_key_id           = ""
}
