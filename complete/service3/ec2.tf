module "ec2" {
  source = "./modules/app/ec2"

  instance_name        = ""
  ami                  = ""
  instance_type        = ""
  availability_zone    = ""
  subnet_id            = ""
  sg_ids               = []
  iam_instance_profile = ""
  ebs_volumes          = {}
  kms_key_id           = ""
}

