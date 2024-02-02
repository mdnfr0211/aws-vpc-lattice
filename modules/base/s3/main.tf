resource "random_string" "main" {
  length           = 8
  special          = false
  upper            = false
  override_special = "/@£$"
}

module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.0"

  bucket = "${var.bucket_name}-${random_string.main.result}"
  acl    = var.acl

  force_destroy = true

  control_object_ownership = true
  object_ownership         = var.object_ownership

  attach_lb_log_delivery_policy  = var.attach_lb_log
  attach_elb_log_delivery_policy = var.attach_lb_log
}
