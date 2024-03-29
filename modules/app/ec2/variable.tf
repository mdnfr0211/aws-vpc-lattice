variable "instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
}

variable "availability_zone" {
  description = " AZ to provision the Instance in"
  type        = string
}

variable "subnet_id" {
  description = "VPC Subnet ID to launch the instance in"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
}

variable "user_data" {
  description = "The user data to provide when launching the instance. Do not pass gzip-compressed data via this argument"
  type        = string
  default     = null
}

variable "ebs_volumes" {
  description = "Map of EBS Additional Volumes to be attached with the ec2 instance"
  type        = map(any)
  default     = {}
}

variable "kms_key_arn" {
  description = "The ARN for the KMS encryption key"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC in which SG needs to be created"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
