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

variable "sg_ids" {
  description = " List of security group IDs to associate the instance with"
  type        = list(string)
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to launch the instance with. Specified as the name of the Instance Profile"
  type        = string
}

variable "create_ebs_volume" {
  description = "Whether to create the additional ebs volume"
  type        = bool
  default     = true
}

variable "ebs_volumes" {
  description = "Map of EBS Additional Volumes to be attached with the ec2 instance"
  type        = map(any)
  default     = {}
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
