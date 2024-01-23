data "template_file" "nginx" {
  template = file("${path.module}/nginx.sh")
}

module "ec2" {
  source = "../../modules/app/ec2"

  instance_name        = format("%s-%s", var.instance_name, var.env)
  ami                  = data.aws_ami.ubuntu.id
  instance_type        = var.instance_type
  availability_zone    = data.aws_availability_zones.available.names[0]
  vpc_id               = module.vpc.id
  subnet_id            = module.vpc.private_subnet_ids[0]
  iam_instance_profile = module.iam.iam_instance_profile_name
  user_data            = data.template_file.nginx.rendered
  ebs_volumes = {
    data = {
      device_name = "/dev/sdf"
      size        = 30
      type        = "gp3"
      iops        = 3000
      throughput  = 125
    }
  }
  kms_key_arn = data.aws_kms_key.ebs.arn
}
