module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "5.5.0"

  name = var.instance_name

  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.sg_ids
  associate_public_ip_address = false

  create_iam_instance_profile = false
  iam_instance_profile        = var.iam_instance_profile

  user_data = var.user_data

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = 50
      tags = {
        Name = format("%s - %s", var.instance_name, "/dev/sda1")
      }
    }
  ]

  tags = merge(
    { Name = var.instance_name },
    var.tags
  )
}


resource "aws_volume_attachment" "main" {
  for_each = var.ebs_volumes

  device_name = each.value.device_name
  volume_id   = aws_ebs_volume.main[each.key].id
  instance_id = module.ec2.id
}

resource "aws_ebs_volume" "main" {
  for_each = var.ebs_volumes

  availability_zone    = var.availability_zone
  size                 = each.value.size
  encrypted            = true
  iops                 = each.value.type == "gp3" || each.value.type == "io1" || each.value.type == "io2" ? each.value.iops : null
  type                 = each.value.type
  throughput           = each.value.type == "gp3" ? each.value.throughput : null
  multi_attach_enabled = each.value.type == "io1" || each.value.type == "io2" ? each.value.multi_attach_enabled : null
  kms_key_id           = var.kms_key_arn

  tags = merge(
    { Name = format("%s - %s", var.instance_name, each.value.device_name) },
    var.tags
  )
}
